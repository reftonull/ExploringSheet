//
//  CustomSheet.swift
//  SheetExploration
//
//  Created by Laksh Chakraborty on 4/5/24.
//

import SwiftUI

struct CustomSheetInternalModifier: ViewModifier {
    @State private var offset: CGFloat = 0
    
    var dismissAction: CustomDismissAction
    
    func body(content: Content) -> some View {
        content
            .background(.background.secondary, in: .rect(cornerRadius: 50))
            .padding(4)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        offset = clip (
                            value: value.translation.height,
                            lower: -30,
                            upper: .infinity
                        )
                    }
                    .onEnded { value in
                        if value.predictedEndTranslation.height > 100 {
                            dismissAction()
                        }
                        offset = 0
                    }
            )
            .drawingGroup()
            .zIndex(1)
            .offset(y: offset)
            .animation(.spring, value: offset)
            .transition(.move(edge: .bottom))
            .environment(\.customIsPresented, true)
            .environment(\.customDismiss, dismissAction)
    }
}

struct CustomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var dismiss: (() -> Void)?
    @ViewBuilder var sheetContent: () -> SheetContent
    
    init(isPresented: Binding<Bool>, onDismiss dismiss: (() -> Void)? = nil, sheetContent: @escaping () -> SheetContent) {
        self._isPresented = isPresented
        self.dismiss = dismiss
        self.sheetContent = sheetContent
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .overlay {
                    Color.black.opacity(isPresented ? 0.3 : 0.0)
                }
            
            if isPresented {
                sheetContent()
                    .modifier(CustomSheetInternalModifier(dismissAction: CustomDismissAction { isPresented = false }))
            }
        }
        .animation(.snappy(duration: 0.3), value: isPresented)
        .ignoresSafeArea(.all, edges: .bottom)
        .onChange(of: isPresented) { oldValue, newValue in
            if oldValue && !newValue {
                dismiss?()
            }
        }
    }
}

struct CustomItemSheet<Item: Identifiable, SheetContent: View>: ViewModifier {
    @Binding var item: Item?
    var dismiss: (() -> Void)?
    @ViewBuilder var sheetContent: (Item) -> SheetContent
    
    init(item: Binding<Item?>, onDismiss dismiss: (() -> Void)? = nil, sheetContent: @escaping (Item) -> SheetContent) {
        self._item = item
        self.dismiss = dismiss
        self.sheetContent = sheetContent
    }
    
    var isPresented: Bool {
        item != nil
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .overlay {
                    Color.black.opacity(isPresented ? 0.3 : 0.0)
                }
            
            if let item {
                sheetContent(item)
                    .modifier(CustomSheetInternalModifier(dismissAction: CustomDismissAction { self.item = nil }))
            }
        }
        .animation(.snappy(duration: 0.3), value: isPresented)
        .ignoresSafeArea(.all, edges: .bottom)
        .onChange(of: isPresented) { oldValue, newValue in
            if oldValue && !newValue {
                dismiss?()
            }
        }
    }
}

extension View {
    func customSheet<SheetContent>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) -> some View where SheetContent: View {
        modifier(
            CustomSheet(
                isPresented: isPresented,
                onDismiss: onDismiss,
                sheetContent: sheetContent
            )
        )
    }
    
    func customSheet<Item, SheetContent>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder sheetContent: @escaping (Item) -> SheetContent
    ) -> some View where Item: Identifiable, SheetContent: View {
        modifier(
            CustomItemSheet(
                item: item,
                onDismiss: onDismiss,
                sheetContent: sheetContent
            )
        )
    }
}
