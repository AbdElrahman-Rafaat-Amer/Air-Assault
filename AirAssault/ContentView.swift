//
//  ContentView.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 07/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: GameView()){
                    Text("Play")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
