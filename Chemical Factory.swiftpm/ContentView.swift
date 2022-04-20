import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        SpriteView(scene: GameScene(fileNamed: "GameScene")!)
            
    }
}
