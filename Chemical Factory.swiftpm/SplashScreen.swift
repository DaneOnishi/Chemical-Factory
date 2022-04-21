//
//  GameScene.swift
//  Chemical Factory
//
//  Created by Daniella Onishi on 18/04/22.
//

import SpriteKit

class SplashScreen: SKScene {
    
    var logo:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        logo = (childNode(withName: "Chemical Factory Logo") as! SKSpriteNode)
        setupLogoAnimation()
    }
    
    func setupLogoAnimation() {
        var scale = SKAction.scale(by: 2, duration: 1)
        var fadeAlpha = SKAction.fadeAlpha(to: 0, duration: 0.4)
        
        logo.run(SKAction.sequence([scale,fadeAlpha]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

