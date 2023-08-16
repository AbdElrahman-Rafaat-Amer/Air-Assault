//
//  GameView.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 07/08/2023.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct GameView: View {
    @State private var points = 0
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                let gameScene = GameScene(size: proxy.size)
                let _ = gameScene.gameDelegate = self
                SpriteView(scene: gameScene).frame(width: proxy.size.width, height: proxy.size.height)
                HStack(){
                    Text("Points:").font(.system(size: 25)).foregroundColor(Color.white)
                    
                    Text("\(points)").font(.system(size: 25)).foregroundColor(Color.white)
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
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

extension GameView : GameProtocol{
    func onGetPoints(points: Int) {
        self.points += points
    }
    
    func onGameOver() {
        saveScore()
    }
    
    private func saveScore(){
        let highScore = UserDefulatManager.INSTANCE.getHighScore()
        if (points > highScore) {
            UserDefulatManager.INSTANCE.saveHighScore(score: points)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
