//
//  Untitled.swift
//  NawafilApp
//
//  Created by Eatzaz Hafiz on 03/02/2026.
//


import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                Text("صلاة الضحى")
                    .foregroundColor(.titlecolor)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                ZStack{
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.cards, Color.cards.opacity(0.6)
                                ], startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 219, height: 390)
                        .cornerRadius(24)
                    VStack {
                        Text("حكمها")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                            Text("المساعدة والمساعدات")
                        Spacer()


                    }
                    .frame(width: 214, height: 390)
                    
                    }

                Spacer()
                    
            }
            .navigationBarTitleDisplayMode( .inline )
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        Button{
                            
                        } label: {
                            Image(systemName: "bell.fill")
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}

