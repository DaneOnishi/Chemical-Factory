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
        let scene = FinalScreen(fileNamed: "6.Final")!
        scene.performNavigation = performNavigation
        return scene
    }
    
    var witch: SKSpriteNode!
    var rat: SKSpriteNode!
    var talkPopUp: SKSpriteNode!
    var background: SKSpriteNode!
    var nextButton: SKSpriteNode!
    var finalDialogues: [String] = [
        "bye 2","bye 1"
    ]
    var elRato: SKSpriteNode!
    private var animation: SKAction!
    
    override func didMove(to view: SKView) {
       
        witch = (childNode(withName: "Witch") as! SKSpriteNode)
        rat = (childNode(withName: "Rat") as! SKSpriteNode)
        nextButton = (childNode(withName: "Next Button") as! SKSpriteNode)
        talkPopUp = (childNode(withName: "Talk Pop Up") as! SKSpriteNode)
        elRato = childNode(withName: "el rato 1-L") as! SKSpriteNode
        animationSetup()
        
        witch.alpha = 0
        rat.alpha = 0
        talkPopUp.alpha = 0
        nextButton.alpha = 0
        
        run(.sequence([
            .wait(forDuration: 1),
            .run {
                self.witch.alpha = 1
                self.rat.alpha = 1
                self.talkPopUp.alpha = 1
                self.nextButton.alpha = 1
            }
        ]))
        
        if finalDialogues.count >= 1 {
            let dialogueName = finalDialogues.removeFirst()
            talkPopUp.texture = SKTexture(imageNamed: dialogueName)
        }
    }
    
    func nextScreen() {
    }
    
    func animationSetup() {
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "el rato 2-L"))
        textures.append(SKTexture(imageNamed: "el rato 3-L"))
        textures.append(SKTexture(imageNamed: "el rato 4-L"))
        textures.append(SKTexture(imageNamed: "el rato 5-L"))
        textures.append(SKTexture(imageNamed: "el rato 4-L"))
        textures.append(SKTexture(imageNamed: "el rato 3-L"))
        textures.append(SKTexture(imageNamed: "el rato 2-L"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: true, restore: false)
        
        animation = SKAction.repeatForever(frames)
        elRato.run(animation)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }

    func touchDown(atPoint pos : CGPoint) {
        if nextButton.contains(pos) {
            if finalDialogues.count >= 1 {
                let dialogueName = finalDialogues.removeFirst()
                talkPopUp.texture = SKTexture(imageNamed: dialogueName)
            } else if finalDialogues.count < 1 {
                performNavigation?()
            }
            
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

