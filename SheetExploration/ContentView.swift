//
//  ContentView.swift
//  SheetExploration
//
//  Created by Laksh Chakraborty on 4/4/24.
//

import SwiftUI

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

#Preview {
    ContentView()
}
