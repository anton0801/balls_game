//
//  MenuScreen2.swift
//  BallsGame
//
//  Created by Anton on 2/5/24.
//

import SwiftUI

struct MenuScreen2: View {
    
    @State var showNavigation = false
    
    var body: some View {
        VStack {
            BallsGameUIViewRep(u: URL(string: UserDefaults.standard.string(forKey: "l_save") ?? "")!)
            if showNavigation {
                HStack {
                  Button {
                      NotificationCenter.default.post(name: .goBackNotification, object: nil)
                  } label: {
                      Image(systemName: "arrow.left")
                          .resizable()
                          .frame(width: 24, height: 24)
                          .foregroundColor(.blue)
                  }
                  
                  Spacer()
                  
                  Button {
                      NotificationCenter.default.post(name: .reloadNotification, object: nil)
                  } label: {
                      Image(systemName: "arrow.clockwise")
                          .resizable()
                          .frame(width: 24, height: 24)
                          .foregroundColor(.blue)
                  }
              }
              .padding(6)
            }
        }
        .edgesIgnoringSafeArea([.bottom,.trailing,.leading])
        .preferredColorScheme(.dark)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SHOW_N"))) { _ in
            showNavigation = true
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("HIDE_N"))) { _ in
            showNavigation = false
        }
    }
}

#Preview {
    MenuScreen2()
}
