//
//  SettingsScreenView.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import SwiftUI

struct SettingsScreenView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var isMusicEnabled = UserDefaults.standard.bool(forKey: ConstNames.isMusicOn.rawValue) {
        didSet {
            UserDefaults.standard.set(isMusicEnabled, forKey: ConstNames.isMusicOn.rawValue)
        }
    }
    @State var isSoundsEnabled = UserDefaults.standard.bool(forKey: ConstNames.isSoundOne.rawValue) {
        didSet {
            UserDefaults.standard.set(isSoundsEnabled, forKey: ConstNames.isSoundOne.rawValue)
        }
    }
    
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
            
            Image("audio_settings")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 30, height: 35)
                .padding([.leading, .trailing])
            
            HStack {
                HStack {
                    Image("ic_music")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading) {
                        Text("SOUND")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text("ON")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.leading, 5)
                .background(
                    Image("settings_item_bg")
                        .resizable()
                        .frame(height: 60)
                )
                
                Spacer().frame(width: 12)
                
                ZStack {
                    Image("settings_item_bg_small")
                        .resizable()
                        .frame(height: 60)
                    Toggle(isOn: $isSoundsEnabled) {
                    }
                    .frame(width: 60)
                    .onChange(of: isSoundsEnabled) { n in
                        isSoundsEnabled = n
                    }
                }
                .frame(width: 80)
            }
            .padding([.leading, .trailing])
            
            HStack {
                HStack {
                    Image("ic_audio")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading) {
                        Text("MUSIC")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text("ON")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.leading, 5)
                .background(
                    Image("settings_item_bg")
                        .resizable()
                        .frame(height: 60)
                )
                
                Spacer().frame(width: 12)
                
                ZStack {
                    Image("settings_item_bg_small")
                        .resizable()
                        .frame(height: 60)
                    Toggle(isOn: $isMusicEnabled) {
                    }
                    .frame(width: 60)
                    .onChange(of: isMusicEnabled) { n in
                        isMusicEnabled = n
                    }
                }
                .frame(width: 80)
            }
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
    SettingsScreenView()
        .environmentObject(PlayerData())
}
