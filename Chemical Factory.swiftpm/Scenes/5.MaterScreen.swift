//
//  File.swift
//  
//
//  Created by Daniella Onishi on 21/04/22.
//

import SpriteKit
import AVFoundation
import CoreAudio


class MaterScreen: SKScene {
    var imageList: [SKSpriteNode]!
    var waterItem: SKSpriteNode!
    var fireItem: SKSpriteNode!
    var iodoItem: SKSpriteNode!
    var potionItem: SKSpriteNode!
    var dragging: SKSpriteNode?
    var originalDraggingPosition: CGPoint?
    var fireParticle: SKReferenceNode!
    var hitBox: SKShapeNode!
    var hitBox2: SKShapeNode!
    var calderone: SKSpriteNode!
    var popUp: SKSpriteNode!
    var imagePlaceholder: SKSpriteNode!
    var label: SKLabelNode!
    
    var recorder: AVAudioRecorder!
    let maxMicLevel: Float = -1.5
    var intensity: CGFloat = 0
    var icedPotion: SKSpriteNode!
    var icedPotionPosition: CGPoint!
    var imagePlaceholderPosition: CGPoint!
    
    override func didMove(to view: SKView) {
        waterItem = (childNode(withName: "Water") as! SKSpriteNode)
        fireItem = (childNode(withName: "Fire") as! SKSpriteNode)
        iodoItem = (childNode(withName: "Iodo") as! SKSpriteNode)
        potionItem = (childNode(withName: "Potion") as! SKSpriteNode)
        calderone = (childNode(withName: "Calderone") as! SKSpriteNode)
        popUp = childNode(withName: "Talk Balone With Witch") as! SKSpriteNode
        
        icedPotion = childNode(withName: "Iced Potion") as! SKSpriteNode
       
        
        hitBox = childNode(withName: "Hit Box") as! SKShapeNode
        hitBox2 = childNode(withName: "Hit Box 2") as! SKShapeNode
        
        fireParticle = childNode(withName: "Fire Particle") as! SKReferenceNode
        fireParticle.alpha = 0
        
        imagePlaceholder = childNode(withName: "Image Placeholder") as! SKSpriteNode
//        imagePlaceholder.alpha = 0
        
        imageList = [waterItem, fireItem, iodoItem, potionItem]
        
        label = childNode(withName: "label") as! SKLabelNode
       
        
        for image in imageList {
            image.alpha = 0.8
        }
        
        initMicrophone()
        
    }
    
    func initMicrophone() {
//        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
//        let url = documents.appendingPathComponent("record.caf")
//        let recordSettings: [String: Any] = [
//            AVFormatIDKey:              kAudioFormatAppleIMA4,
//            AVSampleRateKey:            44100.0,
//            AVNumberOfChannelsKey:      2,
//            AVEncoderBitRateKey:        12800,
//            AVLinearPCMBitDepthKey:     16,
//            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
//        ]
//        
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
//            try audioSession.setActive(true)
//            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
//            
//        } catch {
//            return
//        }
//        
//        recorder.prepareToRecord()
//        recorder.isMeteringEnabled = true
//        recorder.record()
    }
    
    func updateMic() {
//        recorder.updateMeters()
//        let level = recorder.averagePower(forChannel: 0)
//        if level <= -30 {
//            label.text = "Channel 0 Level: \(level)\n Channel 1 Level: \(recorder.averagePower(forChannel: 1))\n Channel 2 Level: \(recorder.averagePower(forChannel: 2))"
//            return
//        }
//
//        let proportion = CGFloat(maxMicLevel / level)
//
//        intensity = min(intensity + proportion * 0.037, 1)
//
//        label.text = "Intensity: \(intensity)\n Level: \(level)\n Proportion\(proportion)"
    }
    
    func enableNodes(nodes: [SKSpriteNode]) {
        for node in nodes {
            node.alpha = 1
        }
    }
    
    fileprivate func updateScene() {
        icedPotion.alpha = intensity
        imagePlaceholder.alpha = 1 - intensity
    
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        updateMic()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        for imagem in imageList {
            if imagem.contains(pos) {
                dragging = imagem
                originalDraggingPosition = imagem.position
                imagem.setScale(1.15)
                return
            }
        }
        
        
    }
    
    
    func touchUp(atPoint pos : CGPoint) {
        dragging?.setScale(1)
        if let originalDraggingPosition = originalDraggingPosition {
            dragging?.position = originalDraggingPosition
        }
        
        if hitBox.contains(pos) {
            if dragging?.name == waterItem.name {
                let texture = SKTexture(imageNamed: "Calderone with blue liquid")
                calderone.size = texture.size()
                calderone.texture = texture
                popUp.texture = SKTexture(imageNamed: "Talk Balone With Witch")
            } else if dragging?.name == fireItem.name {
                fireParticle.alpha = 1
                let texture = SKTexture(imageNamed: "Calderone with bubbles")
                calderone.size = texture.size()
                calderone.texture = texture
                fireParticle.alpha = 1
                popUp.texture = SKTexture(imageNamed: "Talk Balone With Witch")
            }
            dragging = nil
        }
        
        if hitBox2.contains(pos) {
            if dragging?.name == iodoItem.name {
                let texture = SKTexture(imageNamed: "Iodo")
                imagePlaceholder.size = texture.size()
                imagePlaceholder.texture = texture
                imagePlaceholder.alpha = 1
                popUp.texture = SKTexture(imageNamed: "Talk Balone With Witch")
            } else if dragging?.name == potionItem.name {
                let texture = SKTexture(imageNamed: "Potion Empty")
                imagePlaceholder.size = texture.size()
                imagePlaceholder.texture = texture
                imagePlaceholder.alpha = 1
                popUp.texture = SKTexture(imageNamed: "Talk Balone With Witch")
                updateScene()
            }
            dragging = nil
            
        }
    }
    
    func touchMoved(atPoint pos : CGPoint) {
        dragging?.position = pos
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
