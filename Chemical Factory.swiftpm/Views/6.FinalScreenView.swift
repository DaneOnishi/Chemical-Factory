//
//  File.swift
//
//
//  Created by Daniella Onishi on 23/04/22.
//

import Foundation
import SwiftUI
import SpriteKit

struct FinalScreenView: View {
    @State var navigated = false

    var body: some View {

        VStack {
            NavigationLink(isActive: $navigated, destination: {
                MenuScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: FinalScreen.buildScene(performNavigation: {
                navigated = true
            }))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
