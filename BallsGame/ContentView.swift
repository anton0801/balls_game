//
//  ContentView.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if UserDefaults.standard.string(forKey: "l_save") != nil {
            MenuScreen2()
         } else {
             MenuScreen()
         }
    }
}

#Preview {
    ContentView()
}
