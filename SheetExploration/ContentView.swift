//
//  ContentView.swift
//  SheetExploration
//
//  Created by Laksh Chakraborty on 4/4/24.
//

import SwiftUI

public func clip<T: FloatingPoint>(value: T, lower: T, upper: T) -> T {
    min(upper, max(value, lower))
}

struct InnerView: View {
    var body: some View {
        VStack {
            Text("Personalized Spatial Audio")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("Use your iPhone to scan your ear geometry for improved spatial audio.")
                .multilineTextAlignment(.center)
            Image(.spatial)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            Button {
                
            } label: {
                Text("Get Started")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.primary)
            .fontWeight(.medium)
            Button("Not Now") {
                
            }
        }
        .padding()
    }
}

struct ContentView: View {
    @State var isPresented: Bool = true
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button("Present Sheet") {
                    isPresented = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .customSheet(isPresented: $isPresented) {
            InnerView()
        }
    }
}



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

#Preview {
    InnerView()
}
