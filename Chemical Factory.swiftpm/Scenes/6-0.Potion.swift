//
//  File.swift
//  
//
//  Created by Daniella Onishi on 22/04/22.
//

import Foundation
import SpriteKit

class Potion: SKScene {
    
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> Potion {
        let scene = Potion(fileNamed: "6-0.Potion")!
        scene.performNavigation = performNavigation
        return scene
    }
    
    var potion: SKSpriteNode!
    var stars: [SKSpriteNode]!
    var lightNode: SKLightNode!
    var lightNode2: SKLightNode!
    var sparks: SKReferenceNode!
    var lightInitialPosition: CGPoint!
    var lightFinalPosition: CGPoint!
    
    override func didMove(to view: SKView) {
        potion = (childNode(withName: "Potion") as! SKSpriteNode)
        sparks = (childNode(withName: "Sparks") as! SKReferenceNode)
        lightNode = (childNode(withName: "Light") as! SKLightNode)
        // setupStarsAnimation()
        setupPotionAnimation()
        setupLightAnimation()

    }
    
    func setupPotionAnimation() {
        let scaleUP = SKAction.scale(by: 1.5, duration: 0.5)
        let scaleDown = SKAction.scale(by: 0.8, duration: 0.5)
        potion.run(SKAction.sequence([scaleUP,scaleDown]))
    }
    
    func setupLightAnimation() {
        lightInitialPosition = CGPoint(x: -130, y: 0)
        lightNode.position = lightInitialPosition
        lightFinalPosition = CGPoint(x: 130, y: 0)
        
        let moveLight = SKAction.move(to: lightFinalPosition, duration: 0.5)
        lightNode.run(
            .sequence([
                .wait(forDuration: 1.5),
                moveLight
            ]))
    }
    
//    func setupStarsAnimation() {
//        for star in stars {
//            star.texture = SKTexture(imageNamed: "Star")
//            let fadeAlpha = SKAction.fadeAlpha(to: 0, duration: 0.4)
//            let increaseAlpha = SKAction.fadeAlpha(to: 1, duration: 0.4)
//
//            star.run(SKAction.sequence([fadeAlpha,increaseAlpha]))
//        }
//    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
