//
//  File.swift
//  
//
//  Created by Daniella Onishi on 20/04/22.
//

import Foundation
import SpriteKit
import AVFoundation

class MenuScreen: SKScene {
    
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> MenuScreen {
        let scene = MenuScreen(fileNamed: "1.MenuScreen")!
        scene.performNavigation = performNavigation
        return scene
    }
    
    var factory:SKSpriteNode!
    var elRato: SKSpriteNode!
    var playButton: SKSpriteNode!
    var soundButton:SKSpriteNode!
    var noSoundButton:SKSpriteNode!
    var contentButton: SKSpriteNode!
    private var animation: SKAction!
    var isSoundButtonActive = true
    
    override func didMove(to view: SKView) {
        factory = (childNode(withName: "Factory Big") as! SKSpriteNode)
        elRato = factory.childNode(withName: "el rato 1-L") as! SKSpriteNode
        playButton = childNode(withName: "Play Button") as! SKSpriteNode
        soundButton = (childNode(withName: "Sound Button") as! SKSpriteNode)
        contentButton = childNode(withName: "Content Button") as! SKSpriteNode
        elRato.position = CGPoint(x: 150, y: 200)
        animationSetup()
        
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
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.01, resize: true, restore: false)
        
        animation = SKAction.repeatForever(frames)
        elRato.run(animation)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
  /*  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
   */
    
    func touchUp(atPoint pos : CGPoint) {
        if playButton.contains(pos) {
            playButton.alpha = 0.5
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        elRato.run(SKAction.move (to:factory.convert(pos,from: self),duration: 0.4), completion: {
                        print("done")
                })
        if playButton.contains(pos) {
            playButton.alpha = 0.5
            performNavigation?()
        } else if soundButton.contains(pos) {
            soundButton.alpha = 0.5
            isSoundButtonActive.toggle()
            if isSoundButtonActive == false {
                soundButton.texture = SKTexture(imageNamed: "No Sound Button")
            } else if isSoundButtonActive == true {
                soundButton.texture = SKTexture(imageNamed: "Sound Button")
                soundButton.alpha = 1
            }
        } else if contentButton.contains(pos) {
            contentButton.alpha = 0.5
            performNavigation?()
        }
    }
}

