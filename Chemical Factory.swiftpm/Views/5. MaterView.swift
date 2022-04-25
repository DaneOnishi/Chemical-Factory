//
//  File.swift
//
//
//  Created by Daniella Onishi on 23/04/22.
//

import Foundation
import SwiftUI
import SpriteKit

struct MaterView: View {
    @State var navigated = false
    
    var body: some View {
        
        VStack {
            NavigationLink(isActive: $navigated, destination: {
                PotionView()
            }) {
                EmptyView()
            }
            SpriteView(scene: MaterScreen.buildScene(performNavigation: {
                navigated = true
            }))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
