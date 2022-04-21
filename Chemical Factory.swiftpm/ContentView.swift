import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        SpriteView(scene: AtomScreen(fileNamed: "3.Atom")!)
            .ignoresSafeArea()
            
    }
}
