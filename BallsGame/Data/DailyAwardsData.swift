//
//  DailyAwardsData.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import Foundation

class DailyAwardsData: ObservableObject {
    
    var playerData: PlayerData
    
    var allDailyAwards = [
        AwardItem(name: "1_day", reward: 250),
        AwardItem(name: "2_day", reward: 500),
        AwardItem(name: "3_day", reward: 1000),
        AwardItem(name: "4_day", reward: 2500),
        AwardItem(name: "5_day", reward: 2500),
        AwardItem(name: "6_day", reward: 2500),
        AwardItem(name: "7_day", reward: 2500)
    ]
    
    @Published var dailyAwardsAvailable: [String] = []
    @Published var dailyAwardsClaimed: [String] = []
    
    init(playerData: PlayerData) {
        self.playerData = playerData
        initDailyAwards()
    }
    
    private func initDailyAwards() {
        let dailyAwardsClaimedSaved = UserDefaults.standard.string(forKey: ConstNames.dailyAwardsClaimed.rawValue)?.components(separatedBy: ",") ?? []
        for reward in dailyAwardsClaimedSaved {
            dailyAwardsClaimed.append(reward)
        }
        
        var rewardsDiff = [String]()
        for reward in allDailyAwards {
            if !dailyAwardsClaimed.contains(reward.name) {
                rewardsDiff.append(reward.name)
            }
        }
        dailyAwardsAvailable = rewardsDiff
    }
    
    func fromNameToAwardItem(name: String) -> AwardItem {
        return allDailyAwards.filter { $0.name == name }[0]
    }
    
    func getTimeToAvailableClaimAward() -> String {
        let savedDate = UserDefaults.standard.object(forKey: ConstNames.lastClaimedDate.rawValue) as? Date
        guard let claimedDate = savedDate else {
            return ""
        }
        let futureDate = Calendar.current.date(byAdding: .hour, value: 24, to: claimedDate)
        if let futureDate = futureDate {
            return calculateTimeDifference(startDate: Date(), endDate: futureDate)
        }
        return ""
    }
    
    private func calculateTimeDifference(startDate: Date, endDate: Date) -> String {
        let calendar = Calendar.current
        
        let difference = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: endDate)
        
        let hours = difference.hour ?? 0
        let minutes = difference.minute ?? 0
        let seconds = difference.second ?? 0
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func canClaimReward(award: String) -> Bool {
        let savedDate = UserDefaults.standard.object(forKey: ConstNames.lastClaimedDate.rawValue) as? Date
        guard let claimedDate = savedDate else {
            return true
        }
        if dailyAwardsClaimed.contains(award) {
            return false
        }
        return Date().timeIntervalSince(claimedDate) >= 24 * 60 * 60
    }
    
    func claimReward(reward: String) -> Bool {
        let award = fromNameToAwardItem(name: reward)
        if dailyAwardsAvailable[0] == award.name {
            if canClaimReward(award: reward) {
                dailyAwardsClaimed.append(award.name)
                UserDefaults.standard.set(dailyAwardsClaimed.joined(separator: ","), forKey: ConstNames.dailyAwardsClaimed.rawValue)
                playerData.credits += award.reward
                UserDefaults.standard.set(Date(), forKey: ConstNames.lastClaimedDate.rawValue)
                return true
            }
            return false
        }
        return false
    }
    
}
