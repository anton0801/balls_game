//
//  ShopScreenView.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import SwiftUI

struct ShopScreenView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var playerData: PlayerData
    
    @State var shopData: ShopData?
    
    @State var errorBuyAlertShow = false
    
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
            
            ScrollView {
                Image("abilities_label")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width - 24, height: 35)
                    .padding([.leading, .trailing])
                
                VStack {
                    ForEach(shopData?.allAbilities ?? [], id: \.id) { shopItem in
                        HStack {
                            HStack {
                                Image(shopItem.image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                VStack(alignment: .leading) {
                                    Text(shopItem.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .bold))
                                    Text("\(shopData?.itemsCount[shopItem.id] ?? 0) ITEMS")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .regular))
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
                                if let shopData = shopData {
                                    errorBuyAlertShow = !shopData.buyItem(shopItem: shopItem)
                                }
                            } label: {
                                ZStack {
                                    Image("settings_item_bg_small")
                                        .resizable()
                                        .frame(height: 60)
                                    Text("\(shopItem.price)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 26, weight: .bold))
                                }
                                .frame(width: 100)
                            }
                        }
                        .padding(.top, 0.5)
                    }
                }
                .padding([.leading, .trailing])
                
                Image("upgrade_label")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width - 24, height: 35)
                    .padding([.leading, .trailing])
                
                VStack {
                    ForEach(shopData?.allUpgrades ?? [], id: \.id) { shopItem in
                        HStack {
                            HStack {
                                Image(shopItem.image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                VStack(alignment: .leading) {
                                    Text(shopItem.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .bold))
                                    Text("\(shopData?.itemsCount[shopItem.id] ?? 0) LEVEL")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .regular))
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
                                if let shopData = shopData {
                                    errorBuyAlertShow = !shopData.buyItem(shopItem: shopItem)
                                }
                            } label: {
                                ZStack {
                                    Image("settings_item_bg_small")
                                        .resizable()
                                        .frame(height: 60)
                                    Text("\(shopItem.price)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 26, weight: .bold))
                                }
                                .frame(width: 100)
                            }
                        }
                        .padding(.top, 0.5)
                    }
                }
                .padding([.leading, .trailing])
            }
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .onAppear {
            shopData = ShopData(playerData: playerData)
        }
        .alert(isPresented: $errorBuyAlertShow) {
            Alert(title: Text("Error buy item"),
                  message: Text("Looks like you don't have enough credits to buy an upgrade or ability, go to the rewards we give every day or play the game to buy!"),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    ShopScreenView()
        .environmentObject(PlayerData())
}
