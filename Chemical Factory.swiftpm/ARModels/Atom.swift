//
//  File.swift
//  
//
//  Created by Daniella Onishi on 24/04/22.
//

import RealityKit
import UIKit

enum Atom: CaseIterable {
    
    case n
    case o
    case h
    case c
    
    var color: UIColor {
        switch self {
        case .n:
            return .green
        case .o:
            return .blue
        case .h:
            return .red
        case .c:
            return .yellow
        }
    }
    
    var radius: Float {
        switch self {
        case .n:
            return 0.05
        case .o:
            return 0.04
        case .h:
            return 0.03
        case .c:
            return 0.1
        }
    }
    
    var name: String {
        switch self {
        case .n:
            return "n"
        case .o:
            return "o"
        case .h:
            return "h"
        case .c:
            return "c"
        }
    }
    
    
    static func createAtom(atom: Atom) -> Entity & HasCollision {
        let sphereResource = MeshResource.generateSphere(radius: atom.radius)
        var sphereMaterial = PhysicallyBasedMaterial()
        
        sphereMaterial.baseColor.tint = atom.color
        sphereMaterial.baseColor.texture = MaterialParameters.Texture(try! TextureResource.load(named: "texture_2"))
        
        sphereMaterial.normal = .init(texture:
                                         MaterialParameters.Texture(try! TextureResource.load(named: "texture_2_normal")))
        
        sphereMaterial.roughness = 0.9
        sphereMaterial.metallic = .init(floatLiteral: 0)
        
        let sphere = ModelEntity(mesh: sphereResource, materials: [sphereMaterial])
        sphere.name = atom.name
        
        sphere.transform.rotation = .init(angle: Float.random(in: 0...(2 * .pi)), axis: [0, 1, 0])
        
        sphere.generateCollisionShapes(recursive: false)
        
        return sphere
    }
    
}
