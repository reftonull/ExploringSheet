//
//  ContentView.swift
//  SheetExploration
//
//  Created by Laksh Chakraborty on 4/4/24.
//

import SwiftUI

struct InnerView: View {
    @Environment(\.customDismiss) var dismiss
    @Environment(\.customIsPresented) var isInPresentation
    
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
                print(isInPresentation)
                dismiss()
            }
        }
        .padding()
    }
}

struct Item: Identifiable {
    var id: UUID
}

struct ContentView: View {
    @State var isPresented: Bool = true
    @State var item: Item? = nil
    @State var item2: Item? = nil

    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button("Present Custom Sheet") {
                    isPresented = true
                    item = Item(id: UUID())
                } 
                Button("Present Sheet") {
                    isPresented = true
                    item2 = Item(id: UUID())
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .sheet(item: $item2) { item in
            VStack {
                Button {
                    self.item = Item(id: UUID())
                } label: {
                    Text("\(item.id)")
                }
                InnerView()
            }
            .presentationDetents([.medium])
            .presentationCornerRadius(50)
        }
        .customSheet(
            item: $item,
            onDismiss: {
                print("Custom sheet dismissed")
            }
        ) { item in
            VStack {
                Button {
                    self.item = Item(id: UUID())
                } label: {
                    Text("\(item.id)")
                }
                InnerView()
            }
        }
    }
}

#Preview {
    ContentView()
}
