//
//  UserDefultManager.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 16/08/2023.
//

import Foundation

enum UserDefulatManager{
    
   case INSTANCE;
    
    func saveHighScore(score: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.set(score, forKey: "HIGH_SCORE")
        userDefaults.synchronize()
    }
    
    func getHighScore() -> Int{
        UserDefaults.standard.integer(forKey: "HIGH_SCORE")
    }
    
}
