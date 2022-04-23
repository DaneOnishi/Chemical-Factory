////
////  File.swift
////
////
////  Created by Daniella Onishi on 23/04/22.
////
//
//import Foundation
//import SwiftUI
//import SpriteKit
//import RealityKit
//
//struct ARViewScreenView: View {
//    @State var navigated = false
//
//    var body: some View {
//
//        VStack {
//            NavigationLink(isActive: $navigated, destination: {
//                MaterView()
//            }) {
//                EmptyView()
//            }
//            SpriteView(scene: MyARView.buildScene(performNavigation: {
//                navigated = true
//            }))
//        }
//        .ignoresSafeArea()
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
//    }
//}
