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
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> WelcomeScreen {
        let scene = WelcomeScreen(fileNamed: "2.WelcomeScreen")!
        scene.performNavigation = performNavigation
        return scene
    }
    var witch:SKSpriteNode!
    var nextButton: SKSpriteNode!
    var talkPopUp: SKSpriteNode!
    var dialogues: [Dialogue] = [
        Dialogue(popUp: "Dialogue-1", witchImage: .happy),
        Dialogue(popUp: "Dialogue-2", witchImage: .happy),
        Dialogue(popUp: "Dialogue-3", witchImage: .thinking),
        Dialogue(popUp: "Dialogue-4", witchImage: .laughing)
    ]
    
    override func didMove(to view: SKView) {
        witch = (childNode(withName: "Witch") as! SKSpriteNode)
        nextButton = (childNode(withName: "Next Button") as! SKSpriteNode)
        talkPopUp = (childNode(withName: "Talk Pop Up") as! SKSpriteNode)
        
        let dialogue = dialogues.removeFirst()
        talkPopUp.texture = SKTexture(imageNamed: dialogue.popUp)
        witch.texture = SKTexture(imageNamed: dialogue.witchImage.rawValue)
        
        
    }
    
    func nextScreen() {
    }
    
    func setupNextDialogue() {
        if dialogues.count >= 1 {
            let dialogue = dialogues.removeFirst()
            talkPopUp.texture = SKTexture(imageNamed: dialogue.popUp)
            witch.texture = SKTexture(imageNamed: dialogue.witchImage.rawValue)
        } else if dialogues.count == 0 {
            performNavigation?()
        }
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
    case thinking = "Happy Medium"
    case happy = "Witch Medium"
    case laughing = "Laughing Medium"
    case serious = "el rato 1-L"
}


