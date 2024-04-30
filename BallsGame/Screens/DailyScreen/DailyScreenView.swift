//
//  DailyScreenView.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import SwiftUI

struct DailyScreenView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var playerData: PlayerData
    @State var dailyAwardsData: DailyAwardsData?
    
    @State var errorClaimingAlertShow = false
    
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
            
            Image("award_days")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 24, height: 35)
                .padding([.leading, .trailing])
            
            ScrollView {
                ForEach(dailyAwardsData?.allDailyAwards ?? [], id: \.id) { award in
                    HStack {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                                let awardDay = award.name.components(separatedBy: "_")[0]
                                Text(awardDay)
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(Color(red: 254/255, green: 1/255, blue: 154/255))
                            }
                            VStack(alignment: .leading) {
                                Text("DAY")
                                    .foregroundColor(.white)
                                    .font(.system(size: 26, weight: .bold))
                                if dailyAwardsData?.dailyAwardsClaimed.contains(award.name) == true {
                                    Text("RECEIVED")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .regular))
                                } else if dailyAwardsData?.dailyAwardsAvailable[0] == award.name {
                                    if dailyAwardsData?.canClaimReward(award: award.name) == true {
                                        Text("AVAILABLE TO CLAIM")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14, weight: .regular))
                                    } else {
                                        Text("AVAILABLE TO CLAIM IN \(dailyAwardsData?.getTimeToAvailableClaimAward() ?? "")")
                                            .foregroundColor(.white)
                                            .font(.system(size: 10, weight: .regular))
                                    }
                                } else {
                                    Text("NOT RECEIVED")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .regular))
                                }
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
                        
                        Button {
                            if dailyAwardsData?.canClaimReward(award: award.name) == true {
                                errorClaimingAlertShow = !dailyAwardsData!.claimReward(reward: award.name)
                            } else {
                                errorClaimingAlertShow = true
                            }
                        } label: {
                            ZStack {
                                Image("settings_item_bg_small")
                                    .resizable()
                                    .frame(height: 60)
                                Text("\(award.reward)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 26, weight: .bold))
                            }
                            .frame(width: 100)
                        }
                    }
                    .opacity(dailyAwardsData?.dailyAwardsAvailable[0] == award.name ||
                             dailyAwardsData?.dailyAwardsClaimed.contains(award.name) == true ? 1 : 0.6)
                }
            }
            .padding([.leading, .trailing])
        }
        .onAppear {
            dailyAwardsData = DailyAwardsData(playerData: playerData)
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $errorClaimingAlertShow) {
            Alert(title: Text("Error claiming award"),
                  message: Text("Something has gone wrong! This award may have already been claimed or is not available today. Try again later!"),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    DailyScreenView()
        .environmentObject(PlayerData())
}
