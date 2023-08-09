//
//  GameView.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 07/08/2023.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct GameView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack() {
                let scene = GameScene(size: proxy.size)
                SpriteView(scene: scene).frame(width: proxy.size.width, height: proxy.size.height)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(Color.green)
            .navigationBarHidden(true)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
