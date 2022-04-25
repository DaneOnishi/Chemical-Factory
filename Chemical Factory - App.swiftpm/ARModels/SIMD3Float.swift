//
//  SIMD3Float.swift
//  RealityTest
//
//  Created by Daniella Onishi on 24/04/22.
//

import Foundation
import RealityKit

extension SIMD3 where Scalar == Float {
    func length() -> Scalar {
        return sqrt(x * x + y * y + z * z)
    }
    
    func unitary() -> SIMD3 {
        self / length()
    }
    
    // https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
    func rotated(around other: SIMD3<Float>, by radians: Float) -> SIMD3 {
        let k = other.unitary()
        return self * cos(radians) + cross(self, k) * sin(radians) + k * dot(k, self) * (1 - cos(radians))
    }
    
    func resized(by value: Float) -> SIMD3 {
        self * value
    }
    
    func resized(to value: Float) -> SIMD3 {
        unitary() * value
    }
    
    func distance(to other: SIMD3<Float>) -> Float {
        sqrt(pow(self.x - other.x, 2) + pow(self.y - other.y, 2) + pow(self.z - other.z, 2))
    }
}

