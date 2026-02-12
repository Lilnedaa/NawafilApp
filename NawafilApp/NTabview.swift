//
//  NTabview.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 08/02/2026.
//


import SwiftUI

struct NTabview: View {
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        
       TabView(selection: $selectedTab) {

            
           Tracker()
                .tabItem{
                 Image("Tracker")
                                   .renderingMode(.template)
                               
                    
                }.tag(0)
            
            
            
           HomeView()
                .tabItem{
                    Image("Kaaba")
                        .renderingMode(.template)
                               
                    
                }.tag(1)
            
            
            
           Tsbeeh()
                .tabItem{
                    Image("Sebhah")                                   .renderingMode(.template)
                               
                    
                }.tag(2)
            
       
       } 
        .tint(buttonColor)

        
        
        
    }
    
    

}

#Preview {
    NTabview()
}
