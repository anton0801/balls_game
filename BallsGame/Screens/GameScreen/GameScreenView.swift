//
//  GameScreenView.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import SwiftUI
import SpriteKit

struct GameScreenView: View {
    
    @EnvironmentObject var playerData: PlayerData
    @Environment(\.presentationMode) var presMode
    
    private var ballsGameScene: BallsGameScene = BallsGameScene()
    
    @State var pausedGame = false
    @State var gameWin = false
    @State var gameLose = false
    
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
    
    var body: some View {
        ZStack {
            SpriteView(scene: ballsGameScene)
                .ignoresSafeArea()
            
            if pausedGame {
                VStack {
                    HStack {
                        Button {
                            pausedGame = false
                            gameWin = false
                            gameLose = false
                            ballsGameScene.continueGame()
                        } label: {
                            Image("close_btn")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
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
                    
                    Spacer().frame(height: 100)
                    
                    Button {
                        pausedGame = false
                        gameWin = false
                        gameLose = false
                        ballsGameScene.continueGame()
                    } label: {
                        Image("resume_btn")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                    }
                    
                    Button {
                        pausedGame = false
                        gameWin = false
                        gameLose = false
                        ballsGameScene.restartGame()
                    } label: {
                        Image("restart_btn")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                    }
                    
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("go_to_menu_btn")
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
            } else if gameWin {
                VStack {
                    Text("WIN")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 300)
                    
                    Button {
                        pausedGame = false
                        gameWin = false
                        gameLose = false
                        ballsGameScene.restartGame()
                    } label: {
                        Image("restart_btn")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                    }
                    
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("go_to_menu_btn")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                    }
                }
                .background(
                    Image("game_back")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                )
            } else if gameLose {
                VStack {
                    Text("LOSE")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 300)
                    
                    Button {
                        pausedGame = false
                        gameWin = false
                        gameLose = false
                        ballsGameScene.restartGame()
                    } label: {
                        Image("restart_btn")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                    }
                    
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("go_to_menu_btn")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                    }
                }
                .background(
                    Image("game_back")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PAUSE_GAME"))) { _ in
            pausedGame = true
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LOSE_GAME"))) { notification in
            guard let userInfo = notification.userInfo,
                  let creditsAll = userInfo["creditsAll"] as? Int else { return }
            playerData.credits = creditsAll
            gameLose = true
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("WIN_GAMe"))) { notification in
            guard let userInfo = notification.userInfo,
                  let creditsAll = userInfo["creditsAll"] as? Int else { return }
            playerData.credits = creditsAll
            gameWin = true
        }
    }
}

#Preview {
    GameScreenView()
        .environmentObject(PlayerData())
}
