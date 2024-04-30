//
//  PlayerData.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import Foundation

class PlayerData: ObservableObject {
    
    @Published var credits = UserDefaults.standard.integer(forKey: ConstNames.credits.rawValue) {
        didSet {
            UserDefaults.standard.set(credits, forKey: ConstNames.credits.rawValue)
        }
    }
    
}
