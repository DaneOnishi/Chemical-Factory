//
//  MoleculesView.swift
//  RealityTest
//
//  Created by Daniella Onishi on 22/04/22.
//

import Foundation
import CoreGraphics
import RealityKit
import ARKit
import SwiftUI

protocol MoleculesARViewDelegate: AnyObject {
    func moleculeCompleted(molecule: MoleculeType)
}

class MoleculesARView: ARView {
    
    enum State {
        case empty
        case showoff
        case makeMolecules
        case done
    }
    
    // Create a new anchor to add content to
    let anchor = AnchorEntity()
    
    weak var moleculeDelegate: MoleculesARViewDelegate?
    
    var state = State.empty
    
    var atoms: [Entity & HasCollision] = []
    var boilerplateAtoms: [Atom: Entity & HasCollision] = [:]
    
    let makeMoleculesMinDistance: Float = 0.8
    let makeMoleculesMaxDistance: Float = 1.5
    let makeMoleculesMaxHeightDiff: Float = 0.15
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        
        // Start AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical, .horizontal]
        session.run(config)
        
        // Add coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .tracking
        addSubview(coachingOverlay)
        
        // Set debug options
#if DEBUG
        debugOptions = [.showAnchorOrigins]
#endif
        
        renderOptions = [
            .disableGroundingShadows,
            .disableFaceMesh,
            .disableAREnvironmentLighting,
            .disableMotionBlur,
            .disableHDR
        ]
        
        print("Creating view")
        
        scene.anchors.append(anchor)
        
        Atom.allCases.forEach {
            let atom = Atom.createAtom(atom: $0)
            boilerplateAtoms[$0] = atom
        }
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placeAtoms() {
        print("Placing atoms...")
        
        (0...600).forEach({ _ in
            let atom = Atom.random
            let sphere = boilerplateAtoms[atom]!.clone(recursive: true)
            
            let randomX = Float.random(in: -3...3)
            let randomY = Float.random(in: -1.5...1.5)
            let randomZ = Float.random(in: -3...3)
            
            sphere.position = .init(x: randomX, y: randomY, z: randomZ)
            
            anchor.addChild(sphere)
            atoms.append(sphere)
        })
        
        (0...150).forEach({ _ in
            let atom = Atom.random
            let sphere = boilerplateAtoms[atom]!.clone(recursive: true)
            
            let randomX = Float.random(in: -1.5...1.5)
            let randomY = Float.random(in: -0.3...0.3)
            let randomZ = Float.random(in: -1.5...1.5)
            
            sphere.position = .init(x: randomX, y: randomY, z: randomZ)
            
            anchor.addChild(sphere)
            atoms.append(sphere)
        })
    }
    
    func transitionToMakeMolecules() {
        let badAtomsIndexes = atoms.enumerated().compactMap { atom -> Int? in
                let atomTranslation = atom.element.transform.translation
                let distanceToOrigin = atomTranslation.distance(to: .zero)
                if distanceToOrigin < makeMoleculesMinDistance
                    || distanceToOrigin > makeMoleculesMaxDistance
                    || atomTranslation.y < -makeMoleculesMaxHeightDiff
                    || atomTranslation.y > +makeMoleculesMaxHeightDiff {
                    return atom.offset
                }
                return nil
            }
            .sorted()
            .reversed()
        
        badAtomsIndexes.forEach({ i in
            atoms[i].removeFromParent()
            atoms.remove(at: i)
        })
        
        atoms.forEach({ atom in
            installGestures(.translation, for: atom).forEach { gestureRecognizer in
                gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
            }
        })
    }
    
    var lastPoint: CGPoint?
    var currentEntitySimulation: EntitySimulation?
    
    @objc private func handleGesture(_ recognizer: UIGestureRecognizer) {
        guard state == .makeMolecules else { return }
        
        guard let translationGesture = recognizer as? EntityTranslationGestureRecognizer else { return }
        
        switch translationGesture.state {
        case .changed:
            guard let currentEntity = translationGesture.entity as? ModelEntity else { return }
            let lastPoint = translationGesture.location(in: self)
            self.lastPoint = lastPoint
            
//            print("Currently dragging: \(currentEntity.id)")
            
            let allEntities = entities(at: lastPoint)
            let otherEntities = allEntities
                .filter { $0 != currentEntity }
            
            if let firstOtherEntity = otherEntities.first as? ModelEntity,
               allEntities.contains(currentEntity),
               let molecule = MoleculeType.firstMolecule(for: currentEntity.name, and: firstOtherEntity.name) {
                
                if let currentEntitySimulation = currentEntitySimulation {
                    if firstOtherEntity != currentEntitySimulation.anchorEntity {
                        currentEntitySimulation.removeGhosts()
                        self.currentEntitySimulation = nil
                    }
                }
                
                if self.currentEntitySimulation == nil {
                    let newSimulation = EntitySimulation(
                        originEntity: firstOtherEntity,
                        direction: (cameraTransform.translation - firstOtherEntity.position).unitary(),
                        moleculeType: molecule)
                    
                    self.currentEntitySimulation = newSimulation
                }
                
            } else {
                self.currentEntitySimulation?.removeGhosts()
                self.currentEntitySimulation = nil
            }
        case .ended:
            if let lastPoint = lastPoint,
               let currentEntity = translationGesture.entity {
                
                let allEntities = entities(at: lastPoint)
                let otherEntities = allEntities
                    .filter { $0 != currentEntity }

                if otherEntities.first != nil,
                    allEntities.contains(currentEntity),
                    let currentEntitySimulation = currentEntitySimulation {
                    
                    currentEntitySimulation.anchorEntity.collision = nil
                    currentEntitySimulation.anchorEntity.model = nil
                    
                    moleculeDelegate?.moleculeCompleted(molecule: currentEntitySimulation.moleculeType)
                    
                    currentEntity.removeFromParent()
                    self.currentEntitySimulation = nil
                    
                    print("Created succesfully!")
                }
                

            }
        default:
            break
        }
    }
}
