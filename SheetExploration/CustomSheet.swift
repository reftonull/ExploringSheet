//
//  CustomSheet.swift
//  SheetExploration
//
//  Created by Laksh Chakraborty on 4/5/24.
//

import SwiftUI

struct CustomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @State var offset: CGFloat = 0
    
    @ViewBuilder var sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .overlay {
                    Color.black.opacity(isPresented ? 0.3 : 0.0)
                }
            
            if isPresented {
                sheetContent()
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
                                if value.translation.height > 30 {
                                    isPresented = false
                                }
                                offset = 0
                            }
                    )
                    .drawingGroup()
                    .zIndex(1)
                    .offset(y: offset)
                    .animation(.spring, value: offset)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.snappy(duration: 0.3), value: isPresented)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

extension View {
    func customSheet<SheetContent>(
        isPresented: Binding<Bool>,
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) -> some View where SheetContent: View {
        modifier(
            CustomSheet(
                isPresented: isPresented,
                sheetContent: sheetContent
            )
        )
    }
}
