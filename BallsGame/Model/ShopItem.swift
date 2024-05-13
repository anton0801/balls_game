//
//  ShopItem.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import Foundation
import WebKit

struct ShopItem: Identifiable {
    var name: String
    var image: String
    var price: Int
    var id: String
}

extension Notification.Name {
    static let goBackNotification = Notification.Name("goBackNotification")
    static let reloadNotification = Notification.Name("reloadNotification")
}

class BallsGameUtils : ObservableObject {
    @Published var gamesViews : [WKWebView] = []
    @Published var cookies: [HTTPCookie] = []
}
