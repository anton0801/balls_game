//
//  MenuScreen.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import SwiftUI

struct MenuScreen: View {
    
    @StateObject var playerData: PlayerData = PlayerData()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    Text("\(playerData.credits)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 8, leading: 52, bottom: 8, trailing: 52))
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(
                                    Color(red: 254/255, green: 1/255, blue: 154/255)
                                )
                        )
                }
                .padding()
                
                Spacer()
                
                NavigationLink(destination: GameScreenView()
                    .environmentObject(playerData)
                    .navigationBarBackButtonHidden(true)) {
                    Image("play_btn")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                }
                
                NavigationLink(destination: ShopScreenView()
                    .environmentObject(playerData)
                    .navigationBarBackButtonHidden(true)) {
                    Image("shop_btn")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                }
                
                NavigationLink(destination: SettingsScreenView()
                    .environmentObject(playerData)
                    .navigationBarBackButtonHidden(true)) {
                    Image("settings_btn")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                }
                
                NavigationLink(destination: GameRulesView()
                    .environmentObject(playerData)
                    .navigationBarBackButtonHidden(true)) {
                    Image("rules_btn")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                }
                
                NavigationLink(destination: DailyScreenView()
                    .environmentObject(playerData)
                    .navigationBarBackButtonHidden(true)) {
                    Image("daily_btn")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                }
                
                Spacer()
            }
            .background(
                Image("game_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MenuScreen()
}
