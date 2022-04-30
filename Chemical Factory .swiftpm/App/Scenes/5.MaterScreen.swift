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
    
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> MaterScreen {
        let scene = MaterScreen(fileNamed: "5.Mater")!
        scene.performNavigation = performNavigation
        return scene
    }
    
    var imageList: [SKSpriteNode]!
    var waterItem: SKSpriteNode!
    var fireItem: SKSpriteNode!
    var iodoItem: SKSpriteNode!
    var potionItem: SKSpriteNode!
    var dragging: SKSpriteNode?
    var originalDraggingPosition: CGPoint?
    var fireParticle: SKReferenceNode!
    var gasParticle: SKReferenceNode!
    var hitBox: SKShapeNode!
    var hitBox2: SKShapeNode!
    var calderone: SKSpriteNode!
    var popUp: SKSpriteNode!
    var imagePlaceholder: SKSpriteNode!
    var label: SKLabelNode!
    var moleculeImage: SKSpriteNode!
    
    var recorder: AVAudioRecorder!
    let maxMicLevel: Float = -30
    let minMicLevel: Float = -6.5
    var intensity: CGFloat = 0
    var icedPotion: SKSpriteNode!
    var icedPotionPosition: CGPoint!
    var imagePlaceholderPosition: CGPoint!
    var gasMolecules: SKNode!
    var liquidMolecules: SKNode!
    var solidMolecules: SKNode!
    var nextButton: SKSpriteNode!
    var dialogues: [(Bool, SKSpriteNode)]! = [
        (true, SKSpriteNode(imageNamed: "Dialogue-16")),
        (true, SKSpriteNode(imageNamed: "Dialogue-17")),
        (false, SKSpriteNode(imageNamed: "Dialogue-18")),
        (false, SKSpriteNode(imageNamed: "Dialogue-19")),
        (true, SKSpriteNode(imageNamed: "Dialogue-20")),
        (false, SKSpriteNode(imageNamed: "Dialogue-21")),
        (true, SKSpriteNode(imageNamed: "Dialogue-22")),
        (false, SKSpriteNode(imageNamed: "Dialogue-23")),
        (true, SKSpriteNode(imageNamed: "Dialogue-24"))
        
    ]
    
    var actionBlocked = false
    
    var updatingSpritesFromMic = false
    
    override func didMove(to view: SKView) {
        waterItem = (childNode(withName: "Water") as! SKSpriteNode)
        fireItem = (childNode(withName: "Fire") as! SKSpriteNode)
        iodoItem = (childNode(withName: "Iodo") as! SKSpriteNode)
        potionItem = (childNode(withName: "Potion") as! SKSpriteNode)
        calderone = (childNode(withName: "Calderone") as! SKSpriteNode)
        popUp = (childNode(withName: "Talk Balone With Witch") as! SKSpriteNode)
        icedPotion = (childNode(withName: "Iced Potion") as! SKSpriteNode)
        hitBox = (childNode(withName: "Hit Box") as! SKShapeNode)
        hitBox2 = (childNode(withName: "Hit Box 2") as! SKShapeNode)
        fireParticle = (childNode(withName: "Fire Particle") as! SKReferenceNode)
        fireParticle.alpha = 0
        gasParticle = (childNode(withName: "Gas Particle") as! SKReferenceNode)
        gasParticle.alpha = 0
        imagePlaceholder = (childNode(withName: "Image Placeholder") as! SKSpriteNode)
        imagePlaceholder.alpha = 0
        imageList = [waterItem, fireItem, iodoItem, potionItem]
        label = (childNode(withName: "label") as! SKLabelNode)
        gasMolecules = (childNode(withName: "Gas Molecules") as! SKNode)
        liquidMolecules = (childNode(withName: "Liquid Molecules") as! SKNode)
        solidMolecules = (childNode(withName: "Solid Molecules") as! SKNode)
        // moleculeImage = (childNode(withName: "Molecule Image") as! SKSpriteNode)
        nextButton = (childNode(withName: "Next Button") as! SKSpriteNode)
       
        
        initMicrophone()
        updateDialogue()
        
    }
    
    lazy var audioSession = AVAudioSession.sharedInstance()
    
    func initMicrophone() {
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        audioSession.requestRecordPermission { allowed in
            print("AE,", allowed)
            guard allowed else { return }
            self.isSoundAllowed = allowed
            do {
                try self.audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
                try self.audioSession.setActive(true)
                try self.recorder = AVAudioRecorder(url:url, settings: recordSettings)
            } catch {
                return
            }

            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true
            self.recorder.record()
        }
    }
    private var isSoundAllowed: Bool = false
    
    
    func updateMic() {
        guard isSoundAllowed, let recorder = recorder else { return }
        print("UPDATING")
        recorder.updateMeters()
        let level = recorder.averagePower(forChannel: 0)
        if level <= maxMicLevel {
            intensity = 0
            return
        }
        
        let positiveLevel = level * -1

        let proportion = 1 - ((positiveLevel + minMicLevel) / (-maxMicLevel + minMicLevel))
        
        intensity = CGFloat(min(proportion, 1))

        label.text = "Intensity: \(intensity)"
    }
    
    func enableNodes(nodes: [SKSpriteNode]) {
        for node in nodes {
            node.alpha = 1
        }
    }

    func animateBoiling() {
        var boilingSequence = [SKTexture]()
        boilingSequence.append(SKTexture(imageNamed: "C---B-1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-2_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-3_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-4_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-5_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-6_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-7_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-9_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-10"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-9_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-7_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-6_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-5_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-4_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-3_1"))
        boilingSequence.append(SKTexture(imageNamed: "C-B-2_1"))
        boilingSequence.append(SKTexture(imageNamed: "C---B-1"))
        
        let frames = SKAction.animate(with: boilingSequence, timePerFrame: 0.1, resize: false, restore: false)
        let animation = SKAction.repeatForever(frames)
        calderone.run(animation)
    }
    
    fileprivate func updateScene() {
        if updatingSpritesFromMic == true {
            icedPotion.alpha = intensity
            imagePlaceholder.alpha = 1 - intensity
            
            if intensity >= 1 {
                run(.sequence([
                    .wait(forDuration: 1),
                    .run {
                        self.performNavigation?()
                    }
                ]))
            }
        }
        
        if intensity >= 1 {
            updatingSpritesFromMic = false
        }
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        updateMic()
        updateScene()
        
        print(calderone.hasActions())
    }
    
    func updateDialogue() {
        guard !dialogues.isEmpty else { return }
        let (block, dialogue) = dialogues.removeFirst()
        
        popUp.run(.setTexture(dialogue.texture!, resize: false))
        actionBlocked = block
        
        nextButton.isHidden = !block
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if actionBlocked {
            if nextButton.contains(pos) {
                updateDialogue()
            }
        } else {
            for imagem in imageList where imagem.alpha == 1 && imagem.contains(pos) {
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
                updateDialogue()
                let texture = SKTexture(imageNamed: "Calderone with blue liquid")
                
                calderone.size = texture.size()
                calderone.texture = texture
                
                
                gasParticle.alpha = 0
                liquidMolecules.alpha = 1
                solidMolecules.alpha = 0
                gasMolecules.alpha = 0
                
                fireItem.alpha = 1
                waterItem.alpha = 0
                iodoItem.alpha = 0.5
                potionItem.alpha = 0.5
               // moleculeImage.texture = SKTexture(imageNamed: "Water")
            } else if dragging?.name == fireItem.name {
                updateDialogue()
                fireParticle.alpha = 1
                let texture = SKTexture(imageNamed: "C-B-1")
                calderone.size = texture.size()
                calderone.texture = texture
                animateBoiling()
                fireParticle.alpha = 1
//                popUp.texture = SKTexture(imageNamed: "Talk Balone With Witch")
                gasParticle.alpha = 0
                gasMolecules.alpha = 1
                liquidMolecules.alpha = 0
                solidMolecules.alpha = 0
                
                fireItem.alpha = 0
                waterItem.alpha = 0
                iodoItem.alpha = 1
                potionItem.alpha = 0.5
                ////moleculeImage.texture = SKTexture(imageNamed: "Fire")
                
            }
            dragging = nil
        }
        
        if hitBox2.contains(pos) {
            if dragging?.name == iodoItem.name {
                updateDialogue()
                let texture = SKTexture(imageNamed: "Iodo Iso")
                imagePlaceholder.size = texture.size()
                imagePlaceholder.texture = texture
                imagePlaceholder.alpha = 1
                gasParticle.alpha = 1
                solidMolecules.alpha = 0
                liquidMolecules.alpha = 0
//                popUp.texture = SKTexture(imageNamed: "Talk Balone With Witch")
                gasMolecules.alpha = 1
                
                fireItem.alpha = 0
                waterItem.alpha = 0
                iodoItem.alpha = 0
                potionItem.alpha = 1
            } else if dragging?.name == potionItem.name {
                updateDialogue()
                let texture = SKTexture(imageNamed: "Potion Iso")
                imagePlaceholder.size = texture.size()
                imagePlaceholder.texture = texture
                imagePlaceholder.alpha = 1
                gasParticle.alpha = 0
//                popUp.texture = SKTexture(imageNamed: "Talk Balone With Witch")
                solidMolecules.alpha = 1
                gasMolecules.alpha = 0
                liquidMolecules.alpha = 0
                updatingSpritesFromMic = true
                
                fireItem.alpha = 0
                waterItem.alpha = 0
                iodoItem.alpha = 0
                potionItem.alpha = 0
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

enum MaterStates {
    case solid
    case gas
    case liquid
    case sublimation
    
    var moleculeImage: String {
        switch self {
        case .solid:
            return "Iodo"
        case .gas:
            return "Potion"
        case .liquid:
            return "Fire"
        case .sublimation:
            return "Water"
        }
    }
}
