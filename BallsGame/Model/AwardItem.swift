//
//  AwardItem.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import Foundation

struct AwardItem: Identifiable {
    let name: String
    let reward: Int
    let id: String = UUID().uuidString
}
