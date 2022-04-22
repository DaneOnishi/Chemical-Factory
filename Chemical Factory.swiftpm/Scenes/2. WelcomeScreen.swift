//
//  File.swift
//  
//
//  Created by Daniella Onishi on 21/04/22.
//

import Foundation
import SpriteKit
import SwiftUI

class WelcomeScreen: SKScene {
    
    var witch:SKSpriteNode!
    var nextButton: SKSpriteNode!
    var talkPopUp: SKSpriteNode!
    var dialogues: [Dialogue]!
    
    override func didMove(to view: SKView) {
        
        dialogues = [
            Dialogue(popUp: "Talk Balone", witchImage: .happy),
            Dialogue(popUp: "Talk Balone", witchImage: .thinking),
            Dialogue(popUp: "Talk Balone", witchImage: .laughing)
        ]
        
        witch = (childNode(withName: "Witch") as! SKSpriteNode)
        nextButton = (childNode(withName: "Next Button") as! SKSpriteNode)
        talkPopUp = (childNode(withName: "Talk Pop Up") as! SKSpriteNode)
    }
    
    func nextScreen() {
        
    }
    
    func setupNextDialogue() {
            let dialogue = dialogues.removeFirst()
            talkPopUp.texture = SKTexture(imageNamed: dialogue.popUp)
            witch.texture = SKTexture(imageNamed: dialogue.witchImage.rawValue)
    }
    
    
    override func update(_ currentTime: TimeInterval) {

    }

    func touchDown(atPoint pos : CGPoint) {
        if nextButton.contains(pos) {
            setupNextDialogue()
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

struct Dialogue {
    var popUp: String
    var witchImage: WitchMoods
}

enum WitchMoods: String {
    case thinking = "Potion"
    case happy = "Iodo"
    case laughing = "Calderone"
    case serious = "el rato 1-L"
}


