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
    var lightNode: SKLightNode!
    var sparks: SKReferenceNode!
    var lightInitialPosition: CGPoint!
    var lightFinalPosition: CGPoint!
   
    
    override func didMove(to view: SKView) {
        logo = (childNode(withName: "Chemical Factory Logo") as! SKSpriteNode)
        lightNode = (childNode(withName: "Light") as! SKLightNode)
        sparks = (childNode(withName: "Sparks") as! SKReferenceNode)
        setupLogoAnimation()
    }
    
    func setupLogoAnimation() {
        let scaleUP = SKAction.scale(by: 1.5, duration: 1)
        let scaleDown = SKAction.scale(by: 1, duration: 0.1)

        logo.run(SKAction.sequence([scaleUP,scaleDown])) {
            self.performNavigation?()
        }
        
        func setupLightAnimation() {
            lightInitialPosition = CGPoint(x: -160, y: 0)
            lightNode.position = lightInitialPosition
            lightFinalPosition = CGPoint(x: 206, y: 0)
            
            let moveLight = SKAction.move(to: lightFinalPosition, duration: 0.5)
            lightNode.run(
                .sequence([
                    .wait(forDuration: 1.5),
                    moveLight
                ]))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

