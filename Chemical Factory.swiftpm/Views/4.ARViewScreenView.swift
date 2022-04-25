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
    var state: MoleculesARView.State = .empty
    
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
                VStack(alignment: .center) {
                    HStack() {
                        Spacer()
                        Image(vm.currentDialogueName)
                        Spacer()
                    }
                    Spacer()
                    HStack() {
                        if vm.isShowingMoleculeList {
                            Image("Dialogue-11")
                            Spacer()
                        }
                    }
                    Spacer()
                    HStack {
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
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "ARViewNeedsNavigate"))) { _ in
            navigated = true
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @ObservedObject var vm: ARViewContainerViewModel
    
    weak var arViewContainer: MoleculesARView?
    
    func makeUIView(context: Context) -> ARView {
        let arView = MoleculesARView(frame: .zero)
        vm.view = arView
        arView.moleculeDelegate = vm
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

class ARViewContainerViewModel: ObservableObject {
    weak var view: MoleculesARView?
    
    var currentDialogueName: String = "Dialogue-11" // avisa varinha. wow nao tem nada ainda
    var isShowingMoleculeList: Bool = false
    
    var moleculesAddedToScene: [MoleculeType] = []
    
    func changeState(to new: MoleculesARView.State) {
        switch new {
        case .empty:
            break
        case .showoff:
            view?.placeAtoms()
            currentDialogueName = "Dialogue-11" // avisar pra clicar na varinha. wowo tem muitas moleculas
        case .makeMolecules:
            view?.transitionToMakeMolecules()
            isShowingMoleculeList = true
            currentDialogueName = "Dialogue-12" // pessoa vai começar
        case.done:
            break
        }
        view?.state = new
    }
    
    var currentState: MoleculesARView.State? {
        return view?.state
    }
}

extension ARViewContainerViewModel: MoleculesARViewDelegate {
    
    func moleculeCompleted(molecule: MoleculeType) {
        
        switch molecule {
        case .oxigen:
            currentDialogueName = "Dialogue-13"
        case .nitrogen:
            currentDialogueName = "Dialogue-14"
        case .methane:
            currentDialogueName = "Methane-1"
        }
        
        moleculesAddedToScene.append(molecule)
        
        let unique = Array(Set(moleculesAddedToScene))
        
        if unique.count == 3 {
            // Troca de cena
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ARViewNeedsNavigate"), object: nil)
                self.view?.session.pause()
                self.view?.removeFromSuperview()
            }
        }
        
        objectWillChange.send()
    }
    
}

