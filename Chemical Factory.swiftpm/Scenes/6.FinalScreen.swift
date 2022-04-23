//
//  File.swift
//  
//
//  Created by Daniella Onishi on 21/04/22.
//

import Foundation
import SpriteKit

class FinalScreen: SKScene {
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> FinalScreen {
        let scene = FinalScreen(fileNamed: "6.FinalScreen")!
        scene.performNavigation = performNavigation
        return scene
    }
    
    var witch: SKSpriteNode!
    var rat: SKSpriteNode!
    var talkPopUp: SKSpriteNode!
    var background: SKSpriteNode!
    var nextButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
       
        witch = (childNode(withName: "Witch") as! SKSpriteNode)
        rat = (childNode(withName: "Rat") as! SKSpriteNode)
        nextButton = (childNode(withName: "Next Button") as! SKSpriteNode)
        talkPopUp = (childNode(withName: "Talk Pop Up") as! SKSpriteNode)
        
        witch.alpha = 0
        rat.alpha = 0
    }
    
    func nextScreen() {
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {

    }

    func touchDown(atPoint pos : CGPoint) {
        if nextButton.contains(pos) {
            
        }
    }
        
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(atPoint pos : CGPoint) {

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(atPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    
}

