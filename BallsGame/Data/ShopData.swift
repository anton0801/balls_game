//
//  ShopData.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import Foundation

class ShopData: ObservableObject {
    
    var playerData: PlayerData
    
    var allAbilities = [
        ShopItem(name: "Large Platform", image: "shop_ability_1", price: 500, id: "large_platform"),
        ShopItem(name: "So be it", image: "shop_ability_2", price: 2500, id: "so_be_it"),
        ShopItem(name: "Great friend", image: "shop_ability_3", price: 5000, id: "great_friend")
    ]
    
    var allUpgrades = [
        ShopItem(name: "Increase Platform", image: "shop_upgrade_1", price: 500, id: "increase_platform"),
        ShopItem(name: "More time", image: "shop_upgrade_2", price: 750, id: "more_time")
    ]
    
    @Published var itemsCount = [String: Int]()
    
    init(playerData: PlayerData) {
        self.playerData = playerData
        
        for shopItem in (allAbilities + allUpgrades) {
            itemsCount[shopItem.id] = UserDefaults.standard.integer(forKey: "abiupg_count_\(shopItem.id)")
        }
    }
    
    func buyItem(shopItem: ShopItem) -> Bool {
        if playerData.credits >= shopItem.price {
            itemsCount[shopItem.id] = (itemsCount[shopItem.id] ?? 0) + 1
            UserDefaults.standard.set(itemsCount[shopItem.id]!, forKey: "abiupg_count_\(shopItem.id)")
            playerData.credits -= shopItem.price
            return true
        }
        return false
    }
    
}
