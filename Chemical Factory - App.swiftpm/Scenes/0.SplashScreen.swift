//
//  GameScene.swift
//  Chemical Factory
//
//  Created by Daniella Onishi on 18/04/22.
//

import SpriteKit

class SplashScreen: SKScene {
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> SplashScreen {
        let scene = SplashScreen(fileNamed: "0.SplashScreen")!
        scene.performNavigation = performNavigation
        return scene
    }
    
    var logo:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        logo = (childNode(withName: "Chemical Factory Logo") as! SKSpriteNode)
        setupLogoAnimation()
    }
    
    func setupLogoAnimation() {
        var scale = SKAction.scale(by: 2, duration: 1)
        var fadeAlpha = SKAction.fadeAlpha(to: 0, duration: 0.4)
        logo.run(SKAction.sequence([scale,fadeAlpha])) {
            self.performNavigation?()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

