//
//  GameRulesView.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import SwiftUI

struct GameRulesView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var playerData: PlayerData
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("close_btn")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
                
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
            
            Spacer().frame(height: 80)
            
            Image("rules_label")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 24, height: 35)
                .padding([.leading, .trailing])
            
            Image("rules_content")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 24, height: 75)
                .padding([.leading, .trailing])
            
            Spacer()
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    GameRulesView()
        .environmentObject(PlayerData())
}
