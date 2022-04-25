//
//  MoleculeType.swift
//  RealityTest
//
//  Created by Daniella Onishi on 24/04/22.
//

import Foundation

enum MoleculeType: CaseIterable {
    case oxigen
    case nitrogen
    case methane
    
    // direction is a vector from the camera to the node
    func generatePositions(from direction: SIMD3<Float>) -> [(Atom, SIMD3<Float>)] {
        let unitaryDirection = SIMD3<Float>(x: direction.x, y: 0, z: direction.z).unitary()
        
        let rightDirection = unitaryDirection.rotated(around: [0, 1, 0], by: .pi/2)
        
        let length = Float(0.25)
        
        switch self {
        case .oxigen:
            return [
                (.o, .zero),
                (.o, rightDirection * length)
            ]
            
        case .nitrogen:
            return [
                (.n, .zero),
                (.n, [0, length ,0])
                
            ]
        case .methane:
            let backAtom = unitaryDirection.rotated(around: rightDirection, by: .pi/4)
            return [
                (.c, .zero),
                (.h, [0, length,0]),
                (.h, backAtom.resized(to: length)),
                (.h, backAtom.rotated(around: [0,1,0], by: (2 * .pi)/3).resized(to: length)),
                (.h, backAtom.rotated(around: [0,1,0], by: (2 * .pi)/3 * 2).resized(to: length))
            ]
        }
    }
    
    // 0 is the origin
    func getLinks() -> [(Int, Int)] {
        switch self {
        case .nitrogen:
            return [
                (0, 1),
            ]
            
        case .oxigen:
            return [
                (0, 1)
            ]
        case .methane:
            return [
                (0, 1),
                (0, 2),
                (0, 3),
                (0, 4)
            ]
        }
    }
    
    static func firstMolecule(for atomName: String, and otherAtomName: String) -> MoleculeType? {
        
        let firstMatch = allCases
            .map {
                ($0, $0.generatePositions(from: .zero).map { atom, position in
                    return atom.name
                })
            }
            .map { type, array -> (MoleculeType, [String]) in
                
                let unique = Array(Set(array))
                
                // If we'd have only one element, then we keep all elements
                if unique.count == 1 {
                    return (type, array)
                }
                
                return (type, unique)
            }
            .first(where: { type, array in
                guard let firstAtom = array.firstIndex(of: atomName) else { return false }
                var arrayClone = array
                arrayClone.remove(at: firstAtom)
                return arrayClone.contains(otherAtomName)
            })
        
        return firstMatch?.0
    }
}

extension CaseIterable {
    static var random: Self {
        Self.allCases.randomElement()!
    }
}
