import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
//        SpriteView(scene: AtomScreen(fileNamed: "3.Atom")!)
       SpriteView(scene: MaterScreen(fileNamed: "5.Mater")!)
//        SpriteView(scene: WelcomeScreen(fileNamed: "2.WelcomeScreen")!)
//        SpriteView(scene: Potion(fileNamed: "6-0.Potion")!)

            .ignoresSafeArea()
            
    }
}
