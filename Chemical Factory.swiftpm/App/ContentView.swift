import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            SplashScreenView()
//            MaterView()
                .ignoresSafeArea()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }.navigationViewStyle(.stack)
    }
}
