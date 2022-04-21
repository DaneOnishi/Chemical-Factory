//
//  File.swift
//  
//
//  Created by Daniella Onishi on 20/04/22.
//

import Foundation
import SpriteKit

class MenuScreen: SKScene {
    
    var factory:SKSpriteNode!
    var elRato: SKSpriteNode!
    private var animation: SKAction!
    
    override func didMove(to view: SKView) {
        factory = (childNode(withName: "Factory Big") as! SKSpriteNode)
        elRato = factory.childNode(withName: "el rato 1-L") as! SKSpriteNode
        
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
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: true, restore: false)
        
        animation = SKAction.repeatForever(frames)
        elRato.run(animation)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
                elRato.run(SKAction.move (to:factory.convert(pos,from: self),duration: 1.5), completion: {
                        print("done")
                })
        
    }
    
}

