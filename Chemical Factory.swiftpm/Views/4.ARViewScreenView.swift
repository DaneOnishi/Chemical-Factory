//
//  File.swift
//
//
//  Created by Daniella Onishi on 23/04/22.
//

import Foundation
import SwiftUI
import SpriteKit
import RealityKit

struct ARViewScreenView: View {
    
    @State var navigated = false
    @StateObject var vm = ARViewContainerViewModel()
    
    @State var buttonText: String = "empty"

    var body: some View {

        VStack {
            NavigationLink(isActive: $navigated, destination: {
                MaterView()
            }) {
                EmptyView()
            }
            
            ZStack(alignment: .top) {
                ARViewContainer(vm: vm)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("hey gay")
                    Spacer()
                    HStack {
                        EmptyView()
                        Spacer()
                        Text(buttonText)
                            .padding()
                            .background(
                                Color.red
                            )
                            .cornerRadius(16)
                            .onTapGesture {
                                switch vm.currentState {
                                case .empty:
                                    vm.changeState(to: .showoff)
                                    buttonText = "showoff"
                                case .showoff:
                                    vm.changeState(to: .makeMolecules)
                                    buttonText = "makeMolecules"
                                default: break
                                }
                            }
                    }
                }
            }
                
            
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @ObservedObject var vm: ARViewContainerViewModel
    
    weak var arViewContainer: MoleculesARView?
    
    func makeUIView(context: Context) -> ARView {
        let arView = MoleculesARView(frame: .zero)
        vm.view = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

class ARViewContainerViewModel: ObservableObject {
    weak var view: MoleculesARView?
    
    func changeState(to new: MoleculesARView.State) {
        switch new {
        case .empty:
            break
        case .showoff:
            view?.placeAtoms()
        case .makeMolecules:
            view?.transitionToMakeMolecules()
        case.done:
            break
        }
        view?.state = new
    }
    
    var currentState: MoleculesARView.State? {
        return view?.state
    }
}
