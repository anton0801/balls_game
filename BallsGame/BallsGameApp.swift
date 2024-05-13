import SwiftUI
import AppsFlyerLib
import AppTrackingTransparency
import OneSignal
import FacebookCore
import AdSupport
import Combine

class AppDelegate: NSObject, UIApplicationDelegate, AppsFlyerLibDelegate {
    
    @objc func activeAppsf() {
        AppsFlyerLib.shared().start()
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                let userIdfaID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                UserDefaults.standard.set(userIdfaID, forKey: "idfa_user_app")
                
                self.sendAppsfReady(status: status == .authorized)
            }
        }
    }
    
    private func sendAppsfReady(status: Bool) {
        NotificationCenter.default.post(name: Notification.Name("ATTrackingManagerAccepted"), object: nil, userInfo: ["data": status])
    }
    
    private func deffDeeplinkFac() {
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            if let error = error {
            }
            if let url = url {
                UserDefaults.standard.set(url, forKey: "user_deferred_deeplink_facebook")
            }
        }
    }
    
    
    private func initAppsfAndDeff() {
        deffDeeplinkFac()
        AppsFlyerLib.shared().appsFlyerDevKey = "eZcpRP3q9uW4QprwxnUCyM"
        AppsFlyerLib.shared().appleAppID = "6501962202"
        AppsFlyerLib.shared().isDebug = false
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        NotificationCenter.default.addObserver(self, selector: #selector(activeAppsf),
                                             name: UIApplication.didBecomeActiveNotification,
                                             object: nil)
    }
    
    private func initAll(launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
        initAppsfAndDeff()
        inNoti(launchOptions: launchOptions)
    }
    
    private func inNoti(launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
        OneSignal.setLogLevel(.LL_NONE, visualLevel: .LL_NONE)
        OneSignal.setLocationShared(false)
        OneSignal.initWithLaunchOptions(launchOptions)
        
        DispatchQueue.main.async {
            OneSignal.setAppId("04aee7d6-a154-469b-90a5-0ca7f1ab5b55")
        }

        OneSignal.promptForPushNotifications(userResponse: { accepted in
            DispatchQueue.global().asyncAfter(deadline: .now() + 25) {
                let pId = OneSignal.getDeviceState().userId
                UserDefaults.standard.set(pId, forKey: "onesignal_player_id")
                NotificationCenter.default.post(name: Notification.Name("PLAYER_ID_ONESIGNAL"), object: nil, userInfo: ["data": pId ?? ""])
            }
         })
        innittPPOpHan()
    }
    
    private func innittPPOpHan() {
        OneSignal.setNotificationOpenedHandler { data in
                let pushData = data.jsonRepresentation()
                            
                guard let ddaj = try? JSONSerialization.data(withJSONObject: pushData),
                      let ssssjjjs = String(data: ddaj, encoding: .utf8) else {
                    return
                }
                
                if let sesdsa = ssssjjjs.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    let sdaw = URL(string: "https://ballscrusherquest.space/technicalPostback/v1.0/postSessionParams/\(UserDefaults.standard.string(forKey: "session_id") ?? "")?push_data=\(sesdsa)&from_push=true")
                    
                    var qwerq = URLRequest(url: sdaw!)
                    qwerq.httpMethod = "POST"
                    
                    URLSession.shared.dataTask(with: qwerq) { data, response, error in
                        guard let _ = data, error == nil else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }
                    }.resume()
                } else {
                }
            }
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initAll(launchOptions: launchOptions)
        return true
    }
    
    func onAppOpenAttribution(_ data: [AnyHashable : Any]) {
        print("after all onAppOpenAttribution loading data \(data)")
    }

    func onConversionDataSuccess(_ data: [AnyHashable : Any]) {
        do {
            let dsafaxasx = try JSONSerialization.data(withJSONObject: data, options: [])
            if let sadasdassd = String(data: dsafaxasx, encoding: .utf8) {
                UserDefaults.standard.set(sadasdassd, forKey: "user_attr_data")
                NotificationCenter.default.post(name: Notification.Name("APPSData"), object: nil, userInfo: ["data": sadasdassd])
            }
        } catch {
        }
    }

    func onConversionDataFail(_ error: Error) { }
    
}

@main
struct BallsGameApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
        }
    }
}
