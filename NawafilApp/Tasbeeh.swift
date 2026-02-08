
//
//  Tsbeeh.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 03/02/2026.
//



import SwiftUI

struct Tsbeeh: View {
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        
       TabView(selection: $selectedTab) {

            
            ContentView()
                .tabItem{
                    Image("Sebhah")
                                   .renderingMode(.template)
                               
                    
                }.tag(0)
            
            
            
           SalahView()
                .tabItem{
                    Image("Kaaba")
                                   .renderingMode(.template)
                               
                    
                }.tag(1)
            
            
            
            ContentView()
                .tabItem{
                    Image("Tracker")
                                   .renderingMode(.template) 
                               
                    
                }.tag(2)
            
       
        }
        .tint(buttonColor)

        
        
        
    }
}

#Preview {
    Tsbeeh()
}
//jjjjjjjjjjj
