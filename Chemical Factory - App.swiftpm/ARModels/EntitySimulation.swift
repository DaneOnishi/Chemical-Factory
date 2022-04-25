//
//  EntitySimulation.swift
//  RealityTest
//
//  Created by Daniella Onishi on 24/04/22.
//

import RealityKit

class EntitySimulation {
    
    let anchorEntity: ModelEntity
    
    var moleculeEntities: [ModelEntity] = []
    var cylinderEntities: [ModelEntity] = []
    
    let moleculeType: MoleculeType
    
    internal init(originEntity: ModelEntity, direction: SIMD3<Float>, moleculeType: MoleculeType) {
        self.anchorEntity = originEntity
        self.moleculeType = moleculeType
        
        print("\n\nCreating simulation for \(moleculeType)")
        moleculeEntities = moleculeType
            .generatePositions(from: originEntity.position)
            .map({ atom, position in
                let atom = Atom.createAtom(atom: atom)
                atom.position = position
                atom.collision = nil
                
                originEntity.addChild(atom)
                
                return atom as! ModelEntity
            })
        

        cylinderEntities = moleculeType
            .getLinks()
            .map({ i, j in
                let firstEntity = i < 0 ? originEntity: moleculeEntities[i]
                let secondEntity = j < 0 ? originEntity : moleculeEntities[j]
                print("Generating cylinder from \(i) to \(j)")
                return placeCilinder(from: firstEntity, to: secondEntity, parent: originEntity)
            })
    }

    
    /// Always send other as the parent, if one of those is the parent
    func placeCilinder(from first: ModelEntity, to other: ModelEntity, parent: Entity) -> ModelEntity {
        var otherPosition = other.position
        if other == parent {
            otherPosition = .zero
        }
        
        let y = (otherPosition - first.position).length()
        let cilinder = createCilinder(size: SIMD3<Float>(x: 0.02, y: y, z: 0.02))
        
        parent.addChild(cilinder)
        
        cilinder.position = (first.position + otherPosition) / 2
        
        cilinder.transform.rotation = .init(from: .zero, to: .init(x: 0, y: 1, z: 0))
        
        let direction = (first.position - otherPosition).unitary()
        let c = dot(direction, .init(x: 0, y: 1, z: 0))
        let angle = acos(c)
        let axis = cross(direction, .init(x: 0, y: -1, z: 0)).unitary()
        cilinder.transform.rotation = .init(angle: angle, axis: axis)
        
        return cilinder
    }
    
    func createCilinder(size: SIMD3<Float>) -> ModelEntity & HasCollision {
        let cilinderResource = MeshResource.generateBox(size: size, cornerRadius: size.x/2)
        let cilinderMaterial = SimpleMaterial(color: .white, roughness: 1, isMetallic: false)
        let cilinder = ModelEntity(mesh: cilinderResource, materials: [cilinderMaterial])
        return cilinder
    }
    
    func removeGhosts() {
        moleculeEntities.forEach({ $0.removeFromParent() })
        cylinderEntities.forEach({ $0.removeFromParent() })
    }
    
}
