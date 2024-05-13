//
//  BallsGameScene.swift
//  BallsGame
//
//  Created by Anton on 29/4/24.
//

import Foundation
import SpriteKit
import WebKit
import GameKit
import SwiftUI

class BallsGameScene: SKScene {
    
    private var pauseBtn: SKSpriteNode!
    
    private var timeLabel: SKLabelNode!
    private var creditsLabel: SKLabelNode!
    
    private var abilityScalePlatformCountLabel: SKLabelNode!
    private var abilityExplosionCountLabel: SKLabelNode!
    private var abilityScaleBallCountLabel: SKLabelNode!
    
    private var winPoints: SKLabelNode!
    
    private var abilityScalePlatformCount = UserDefaults.standard.integer(forKey: "abiupg_count_large_platform") {
        didSet {
            abilityScalePlatformCountLabel.text = "\(abilityScalePlatformCount) ITEMS"
            UserDefaults.standard.set(abilityScalePlatformCount, forKey: "abiupg_count_large_platform")
        }
    }
    
    private var abilityExplosionCount = UserDefaults.standard.integer(forKey: "abiupg_count_so_be_it") {
        didSet {
            abilityExplosionCountLabel.text = "\(abilityExplosionCount) ITEMS"
            UserDefaults.standard.set(abilityExplosionCount, forKey: "abiupg_count_so_be_it")
        }
    }
    
    private var abilityScaleBallCount = UserDefaults.standard.integer(forKey: "abiupg_count_great_friend") {
        didSet {
            abilityScaleBallCountLabel.text = "\(abilityScaleBallCount) ITEMS"
            UserDefaults.standard.set(abilityScaleBallCount, forKey: "abiupg_count_great_friend")
        }
    }
    
    private var platform: SKSpriteNode!
    private var ball: SKSpriteNode!
    
    private var abilityScalePlatform: SKSpriteNode!
    private var abilityExplosionPlatform: SKSpriteNode!
    private var abilityScaleBall: SKSpriteNode!
    
    private var rowsSpawnerTimer = Timer()
    private var gameTimeTimer = Timer()
    private var abilityTimer = Timer()
    private var abilityTimerScaleBall = Timer()
    
    private var justStartedGame = true
    
    private var timeLeft = 120 {
        didSet {
            timeLabel.text = formatToMinutesSecond()
            if !justStartedGame {
                if timeLeft % 60 == 0 {
                    winPointsFunc()
                }
            }
            if timeLeft == 0 {
                winGame()
            }
            justStartedGame = false
        }
    }
    
    private var credits = UserDefaults.standard.integer(forKey: ConstNames.credits.rawValue) {
        didSet {
            UserDefaults.standard.set(credits, forKey: ConstNames.credits.rawValue)
            creditsLabel.text = "\(credits)"
        }
    }
    
    private func formatToMinutesSecond() -> String {
        let minutes = timeLeft / 60
        let seconds = timeLeft % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func winGame() {
        NotificationCenter.default.post(name: Notification.Name("WIN_GAMe"), object: nil, userInfo: ["creditsAll": credits])
    }
    
    private func winPointsFunc() {
        winPoints = SKLabelNode(text: "+1000")
        winPoints.position = CGPoint(x: size.width - 180, y: size.height - 250)
        winPoints.fontName = ""
        addChild(winPoints)
        
        let actionMoveUp = SKAction.moveTo(y: size.height - 180, duration: 0.5)
        let actionFadeOut = SKAction.fadeOut(withDuration: 0.2)
        let sequence = SKAction.sequence([actionMoveUp, actionFadeOut])
        winPoints.run(sequence) {
            self.credits += 1000
        }
    }
    
    override func didMove(to view: SKView) {
        // physicsWorld.contactDelegate = self
        size = CGSize(width: 750, height: 1335)
        
        let backgroundImage = SKSpriteNode(imageNamed: "game_back")
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.size = CGSize(width: size.width, height: size.height)
        addChild(backgroundImage)
        
        spawnNewRowItems()
        
//        rowsSpawnerTimer = .scheduledTimer(timeInterval: 2, target: self, selector: #selector(spawnNewRowItems), userInfo: nil, repeats: true)
        gameTimeTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimeMinus), userInfo: nil, repeats: true)
        rowsSpawnerTimer = .scheduledTimer(timeInterval: 20, target: self, selector: #selector(spawnNewRowItems), userInfo: nil, repeats: true)
        
        addMenuItems()
        makePlatform()
        makeBall()
        makeInvisibleBorders()
        makeAbilities()
        
        timeLeft = 120 + (UserDefaults.standard.integer(forKey: "abiupg_count_more_time") * 60)
    }
    
    private func makeAbilities() {
        let abilitiesBg = SKSpriteNode(imageNamed: "abilities_bg")
        abilitiesBg.position = CGPoint(x: size.width / 2, y: 70)
        abilitiesBg.size = CGSize(width: size.width - 200, height: 40)
        addChild(abilitiesBg)
        
        abilityScalePlatform = SKSpriteNode(imageNamed: "ability_1")
        abilityScalePlatform.position = CGPoint(x: size.width / 2 - 150, y: 120)
        abilityScalePlatform.size = CGSize(width: 120, height: 110)
        addChild(abilityScalePlatform)
        
        abilityExplosionPlatform = SKSpriteNode(imageNamed: "ability_2")
        abilityExplosionPlatform.position = CGPoint(x: size.width / 2, y: 120)
        abilityExplosionPlatform.size = CGSize(width: 120, height: 110)
        addChild(abilityExplosionPlatform)
        
        abilityScaleBall = SKSpriteNode(imageNamed: "ability_3")
        abilityScaleBall.position = CGPoint(x: size.width / 2 + 150, y: 120)
        abilityScaleBall.size = CGSize(width: 120, height: 110)
        addChild(abilityScaleBall)
        
        let ability1Back = SKSpriteNode(imageNamed: "ability_count_bg")
        ability1Back.position = CGPoint(x: abilityScalePlatform.position.x, y: abilityScalePlatform.position.y + 80)
        ability1Back.size = CGSize(width: abilityScalePlatform.size.width, height: 30)
        addChild(ability1Back)
        
        abilityScalePlatformCountLabel = SKLabelNode(text: "\(abilityScalePlatformCount) ITEMS")
        abilityScalePlatformCountLabel.position = CGPoint(x: ability1Back.position.x, y: ability1Back.position.y - 8)
        abilityScalePlatformCountLabel.fontName = ""
        abilityScalePlatformCountLabel.fontSize = 24
        addChild(abilityScalePlatformCountLabel)
        
        let ability2Back = SKSpriteNode(imageNamed: "ability_count_bg")
        ability2Back.position = CGPoint(x: abilityExplosionPlatform.position.x, y: abilityExplosionPlatform.position.y + 80)
        ability2Back.size = CGSize(width: abilityExplosionPlatform.size.width, height: 30)
        addChild(ability2Back)
        
        abilityExplosionCountLabel = SKLabelNode(text: "\(abilityExplosionCount) ITEMS")
        abilityExplosionCountLabel.position = CGPoint(x: ability2Back.position.x, y: ability2Back.position.y - 8)
        abilityExplosionCountLabel.fontName = ""
        abilityExplosionCountLabel.fontSize = 24
        addChild(abilityExplosionCountLabel)
        
        let ability3Back = SKSpriteNode(imageNamed: "ability_count_bg")
        ability3Back.position = CGPoint(x: abilityScaleBall.position.x, y: abilityScaleBall.position.y + 80)
        ability3Back.size = CGSize(width: abilityScaleBall.size.width, height: 30)
        addChild(ability3Back)
        
        abilityScaleBallCountLabel = SKLabelNode(text: "\(abilityScaleBallCount) ITEMS")
        abilityScaleBallCountLabel.position = CGPoint(x: ability3Back.position.x, y: ability3Back.position.y - 8)
        abilityScaleBallCountLabel.fontName = ""
        abilityScaleBallCountLabel.fontSize = 24
        addChild(abilityScaleBallCountLabel)
    }
    
    private func makeInvisibleBorders() {
        // Создаем левую границу
        let leftBorder = SKNode()
        leftBorder.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: size.height))
        addChild(leftBorder)
        
        // Создаем правую границу
        let rightBorder = SKNode()
        rightBorder.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: size.width, y: 0), to: CGPoint(x: size.width, y: size.height))
        addChild(rightBorder)
    }
    
    private func makeBall() {
        ball = SKSpriteNode(imageNamed: "ball")
        ball.position = CGPoint(x: size.width / 2, y: platform.position.y + 15)
        ball.size = CGSize(width: 30, height: 30)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.contactTestBitMask = 1
        
        addChild(ball)
    }
    
    @objc private func gameTimeMinus() {
        if !isPaused {
            timeLeft -= 1
        }
    }
    
    private func addMenuItems() {
        pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: 80, y: size.height - 120)
        pauseBtn.size = CGSize(width: 70, height: 50)
        addChild(pauseBtn)
        
        let timeLabelBack = SKSpriteNode(imageNamed: "game_info_bg")
        timeLabelBack.position = CGPoint(x: 280, y: size.height - 120)
        timeLabelBack.size = CGSize(width: 200, height: 50)
        addChild(timeLabelBack)
        
        timeLabel = SKLabelNode(text: "02:00")
        timeLabel.position = CGPoint(x: 280, y: size.height - 132)
        timeLabel.fontName = ""
        addChild(timeLabel)
        
        let creditsLabelBack = SKSpriteNode(imageNamed: "game_info_bg")
        creditsLabelBack.position = CGPoint(x: timeLabelBack.position.x + 300, y: size.height - 120)
        creditsLabelBack.size = CGSize(width: 250, height: 50)
        addChild(creditsLabelBack)
        
        creditsLabel = SKLabelNode(text: "\(credits)")
        creditsLabel.position = CGPoint(x: timeLabelBack.position.x + 300, y: size.height - 132)
        creditsLabel.fontName = ""
        addChild(creditsLabel)
    }
    
    private func makePlatform() {
        platform = SKSpriteNode(imageNamed: "balls_catcher")
        let upgradeWidth = UserDefaults.standard.integer(forKey: "abiupg_count_increase_platform")
        platform.size = CGSize(width: 150 + (20 * upgradeWidth), height: 10)
        platform.position = CGPoint(x: size.width / 2, y: 300)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = 3
        platform.physicsBody?.collisionBitMask = 1
        platform.physicsBody?.contactTestBitMask = 1
        platform.name = "platform"
        addChild(platform)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, obstacle) in gameItemNodes.enumerated() {
            let ballFrameWithMargins = ball.frame.insetBy(dx: 0, dy: -7)
            let obstacleFrameWithMargins = obstacle.frame.insetBy(dx: 0, dy: -7)
            if ballFrameWithMargins.intersects(obstacleFrameWithMargins) {
                let ballPositionRelativeToObstacle = ball.position.x - obstacle.position.x
                ball.physicsBody?.applyImpulse(CGVector(dx: ballPositionRelativeToObstacle / 1.2, dy: -12))
                let obstacleText = gameItemNodesText[index]
                if obstacleText.text == "1" {
                    let action = SKAction.fadeOut(withDuration: 0.2)
                    obstacle.run(action) {
                        obstacle.removeFromParent()
                    }
                    obstacleText.run(action) {
                        obstacleText.removeFromParent()
                    }
                } else {
                    obstacleText.text = "1"
                }
            }
        }
        
        if ball.frame.intersects(platform.frame) {
            let ballPositionRelativeToPlatform = ball.position.x - platform.position.x
            ball.physicsBody?.applyImpulse(CGVector(dx: ballPositionRelativeToPlatform / 1.2, dy: 12))
        }
        
        if ball.position.y >= size.height - 200 {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -12))
        }
        
        if ball.position.y <= 0 {
            loseGame()
        }
    }
    
    private func loseGame() {
        NotificationCenter.default.post(name: Notification.Name("LOSE_GAME"), object: nil, userInfo: ["creditsAll": credits])
    }
    
    private var gameRowItems: [[CGFloat: CGFloat]] = [[:]]
    private var gameItemNodes: [SKSpriteNode] = []
    private var gameItemNodesText: [SKLabelNode] = []
    
    @objc private func spawnNewRowItems() {
        var nonEmptyGameRowItems: [[CGFloat: CGFloat]] = []
        for row in gameRowItems {
            if !row.isEmpty {
                nonEmptyGameRowItems.append(row)
            }
        }
        gameRowItems = nonEmptyGameRowItems
        
        let randomSource = GKRandomSource.sharedRandom()
        var itemsInRow = [Int]()
        for _ in 0...7 {
            let randomValue = randomSource.nextInt(upperBound: 2)
            itemsInRow.append(randomValue)
        }
        
        var tempGameRowItems: [[CGFloat: CGFloat]] = [[:]]
        tempGameRowItems.append(contentsOf: gameRowItems)
        
        for (index, row) in tempGameRowItems.enumerated() {
            for (positionX, positionY) in row {
                let rowDictionary = gameRowItems[index - 1]
                if let value = rowDictionary[positionX] {
                    gameRowItems[index - 1][positionX] = value - 100
                }
                for node in nodes(at: CGPoint(x: positionX, y: positionY)) {
                    if node.name == "game_item_row" || node.name == "game_item_row_number" {
                        node.position.y = gameRowItems[index - 1][positionX]!
                    }
                }
            }
        }
        
        var itemsInRowTemp: [CGFloat: CGFloat] = [:]

        for (index, item) in itemsInRow.enumerated() {
            if item == 1 {
                let x = index * 90 + 40
                let y = size.height - 200
                itemsInRowTemp[CGFloat(x)] = y
                makeItemGameItemColumn(x: CGFloat(x), y: y, number: randomSource.nextInt(upperBound: 2) + 1)
            }
        }
        
        gameRowItems.append(itemsInRowTemp)
    }
    
    private func makeItemGameItemColumn(x: CGFloat, y: CGFloat, number: Int) {
        var itemBack = "game_row_item"
        if number == 2 {
            itemBack = "game_row_item_2"
        }
        let itemBackNode = SKSpriteNode(imageNamed: itemBack)
        itemBackNode.physicsBody = SKPhysicsBody(rectangleOf: itemBackNode.size)
        itemBackNode.physicsBody?.isDynamic = false
        itemBackNode.physicsBody?.affectedByGravity = false
        itemBackNode.physicsBody?.categoryBitMask = 2
        itemBackNode.physicsBody?.collisionBitMask = 1
        itemBackNode.physicsBody?.contactTestBitMask = 1
        itemBackNode.position = CGPoint(x: x, y: y)
        itemBackNode.size = CGSize(width: 80, height: 80)
        itemBackNode.name = "game_item_row"
        addChild(itemBackNode)
        
        let itemNum = SKLabelNode(text: "\(number)")
        itemNum.position = CGPoint(x: x, y: y - 10)
        itemNum.fontName = ""
        itemNum.name = "game_item_row_number"
        addChild(itemNum)
        
        gameItemNodes.append(itemBackNode)
        gameItemNodesText.append(itemNum)
        
        let actionFadeOut = SKAction.fadeOut(withDuration: 0.001)
        let actionFadeOut2 = SKAction.fadeOut(withDuration: 0.001)
        let actionFadeIn = SKAction.fadeIn(withDuration: 0.2)
        let actionFadeIn2 = SKAction.fadeIn(withDuration: 0.2)
        let sequince = SKAction.sequence([actionFadeOut, actionFadeIn])
        let sequince2 = SKAction.sequence([actionFadeOut2, actionFadeIn2])
        itemBackNode.run(sequince)
        itemNum.run(sequince2)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locaation = touch.location(in: self)
            platform.position.x = locaation.x
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        
        guard !object.contains(pauseBtn) else {
            pauseGame()
            return
        }       
        
        guard !object.contains(abilityScalePlatform) else {
            scalePlatform()
            return
        }
        
        guard !object.contains(abilityExplosionPlatform) else {
            explosionAll()
            return
        }
        
        guard !object.contains(abilityScaleBall) else {
            scaleBall()
            return
        }
    }
    
    private func scalePlatform() {
        if abilityScalePlatformCount > 0 {
            abilityTimer = .scheduledTimer(timeInterval: 30, target: self, selector: #selector(abilityScalePlatofrmEnd), userInfo: nil, repeats: true)
            let scaleAction = SKAction.scale(to: CGSize(width: platform.size.width + 60, height: platform.size.height), duration: 0.5)
            platform.run(scaleAction)
            abilityScalePlatformCount -= 1
        }
    }
    
    private func explosionAll() {
        if abilityExplosionCount > 0 {
            for node in gameItemNodes {
                node.removeFromParent()
            }
            for node in gameItemNodesText {
                node.removeFromParent()
            }
            gameItemNodes = []
            gameItemNodesText = []
            abilityExplosionCount -= 1
        }
    }
    
    private func scaleBall() {
        if abilityScaleBallCount > 0 {
            abilityTimerScaleBall = .scheduledTimer(timeInterval: 30, target: self, selector: #selector(abilityScaleBallEnd), userInfo: nil, repeats: true)
            let scaleAction = SKAction.scale(to: CGSize(width: ball.size.width + 30, height: ball.size.height + 30), duration: 0.5)
            ball.run(scaleAction)
            abilityScaleBallCount -= 1
        }
    }
    
    @objc private func abilityScalePlatofrmEnd() {
        abilityTimer.invalidate()
        let scaleAction = SKAction.scale(to: CGSize(width: platform.size.width - 60, height: platform.size.height), duration: 0.5)
        platform.run(scaleAction)
    }
    
    @objc private func abilityScaleBallEnd() {
        abilityTimerScaleBall.invalidate()
        let scaleAction = SKAction.scale(to: CGSize(width: ball.size.width - 30, height: ball.size.height - 30), duration: 0.5)
        ball.run(scaleAction)
    }
    
    func restartGame() {
        let newGameScene = BallsGameScene()
        newGameScene.size = CGSize(width: 750, height: 1335)
        view?.presentScene(newGameScene)
    }
    
    func pauseGame() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("PAUSE_GAME"), object: nil, userInfo: nil)
    }
    
    func continueGame() {
        isPaused = false
    }
    
    enum AbilityType: String {
        case scalePlatform = "ability_1"
        case explosionAll = "ability_2"
        case scaleBall = "ability_3"
    }
    
    func calculateResults() {
        var result = 0
        for i in 0..<10 {
            if i % 2 == 0 {
                result += i
            } else {
                result -= i
            }
        }

        var anotherResult = 0
        for j in 0..<10 {
            if j % 2 == 0 {
                anotherResult += j
            } else {
                anotherResult -= j
            }
        }
    }
    
    func calculateTotalPoints() -> Int {
        let timePerPoints = timeLeft * 120
        let ins = timePerPoints / 2
        return ins
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: BallsGameScene())
            .ignoresSafeArea()
    }
}

struct BallsGameUIViewRep: UIViewRepresentable {
    let u: URL
        
    @State var gameMenUtil = BallsGameUtils()

    @State var webView: WKWebView = WKWebView()
    @State var webViews : [WKWebView] = []

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var par: BallsGameUIViewRep

        init(parent: BallsGameUIViewRep) {
            self.par = parent
        }
        
        @objc func handleNotification(_ notification: Notification) {
            if notification.name == .goBackNotification {
                par.goBack()
            } else if notification.name == .reloadNotification {
                par.refresh()
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .goBackNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .reloadNotification, object: nil)
        }
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completionHandler()
            }))
            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let url = navigationAction.request.url {
                let str = url.absoluteString
                if str.hasPrefix("tg://") || str.hasPrefix("viber://") || str.hasPrefix("whatsapp://") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    decisionHandler(.cancel)
                    return
                }
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            guard let currentURL = webView.url else {
                return
            }
            
            let coos: WKHTTPCookieStore? = webView.configuration.websiteDataStore.httpCookieStore
            var coosLst: [String: [String: HTTPCookie]] = [:]
            let userDefaults = UserDefaults.standard
            
            if let dasxsadasd: [String: [String: [HTTPCookiePropertyKey: AnyObject]]]? = (userDefaults.dictionary(forKey: "cookiesKey") ?? [:]) as [String: [String: [HTTPCookiePropertyKey: AnyObject]]] {
                for (domain, cookieMap) in dasxsadasd ?? [:] {
                    var mpaOfDoma = coosLst[domain] ?? [:]
                    for (_, cookie) in cookieMap {
                        if let cookie: [HTTPCookiePropertyKey: AnyObject]? = cookie as [HTTPCookiePropertyKey: AnyObject] {
                            if cookie != nil {
                                let cookieValue = HTTPCookie(properties: cookie!)
                                mpaOfDoma[cookieValue!.name] = cookieValue
                            }
                        }
                    }
                    coosLst[domain] = mpaOfDoma
                }
            }
            if let coos = coos {
                coos.getAllCookies { cookies in
                    for cookie in cookies {
                        var mapCookiesOfDomain = coosLst[cookie.domain] ?? [:]
                        mapCookiesOfDomain[cookie.name] = cookie
                        coosLst[cookie.domain] = mapCookiesOfDomain
                    }
                    self.sadadafadsd(coos: coosLst)
                }
            }
        }
        
        private func sadadafadsd(coos: [String: [String: HTTPCookie]]) {
            let userDefaults = UserDefaults.standard

            var cookieDict = [String : [String: AnyObject]]()

            for (domain, cookieMap) in coos {
                var mapParent = cookieDict[domain] ?? [:]
                for (_, cookie) in cookieMap {
                    mapParent[cookie.name] = cookie.properties as AnyObject?
                }
                cookieDict[domain] = mapParent
            }

            userDefaults.set(cookieDict, forKey: "cookiesKey")
        }

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
              if navigationAction.targetFrame == nil {
                  webView.load(navigationAction.request)
              }
              if navigationAction.targetFrame == nil {
                  let newPopupView = createBallPr(configuration: configuration)
                  return newPopupView
              } else {
                  NotificationCenter.default.post(name: Notification.Name("HIDE_N"), object: nil, userInfo: nil)
              }
              
              return nil
          }
        
        func createBallPr(configuration: WKWebViewConfiguration) -> WKWebView {
            NotificationCenter.default.post(name: Notification.Name("SHOW_N"), object: nil, userInfo: nil)
            let ballPr = WKWebView(frame: .zero, configuration: configuration)
            ballPr.navigationDelegate = self
            ballPr.uiDelegate = self
            ballPr.allowsBackForwardNavigationGestures = true
            ballPr.scrollView.isScrollEnabled = true

            par.webView.addSubview(ballPr)
            ballPr.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                ballPr.topAnchor.constraint(equalTo: par.webView.topAnchor),
                ballPr.bottomAnchor.constraint(equalTo: par.webView.bottomAnchor),
                ballPr.leadingAnchor.constraint(equalTo: par.webView.leadingAnchor),
                ballPr.trailingAnchor.constraint(equalTo: par.webView.trailingAnchor)
            ])
            self.par.gameMenUtil.gamesViews.append(ballPr)
            return ballPr
        }
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let wkPrefs = WKPreferences()
        wkPrefs.javaScriptCanOpenWindowsAutomatically = true
        wkPrefs.javaScriptEnabled = true
        
        let wPaDePref = WKWebpagePreferences()
        wPaDePref.allowsContentJavaScript = true
        
        let conf = WKWebViewConfiguration()
        conf.allowsInlineMediaPlayback = true
        conf.requiresUserActionForMediaPlayback = false
        conf.preferences = wkPrefs
        conf.defaultWebpagePreferences = wPaDePref

        webView = WKWebView(frame: .zero, configuration: conf)
        setGameBall(context: context, webView: webView)
        
        return webView
    }

    private func setGameBall(context: Context, webView: WKWebView) {
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = context.coordinator

        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            let dataStore = webView.configuration.websiteDataStore
            cookies.forEach { cookie in
                dataStore.httpCookieStore.setCookie(cookie)
            }
        }
        
        addiGameBallSet()
    }
    
    private func addiGameBallSet() {
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
                
        let cookstor = HTTPCookieStorage.shared
        let defusr = UserDefaults.standard

        if let cooksadda: [String: [String: [HTTPCookiePropertyKey: AnyObject]]]? = (defusr.dictionary(forKey: "cookiesKey") ?? [:]) as [String: [String: [HTTPCookiePropertyKey: AnyObject]]] {
            for (_, cookieMap) in cooksadda ?? [:] {
                for (_, cookie) in cookieMap {
                    if let cookie: [HTTPCookiePropertyKey: AnyObject]? = cookie as [HTTPCookiePropertyKey: AnyObject] {
                        if cookie != nil {
                            let cookieValue = HTTPCookie(properties: cookie!)
                            cookstor.setCookie(cookieValue!)
                            cookieStore.setCookie(cookieValue!)
                        }
                    }
                }
            }
        }
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: u)
        uiView.load(request)
    }

    func goBack() {
       if gameMenUtil.gamesViews.count > 0 {
            gameMenUtil.gamesViews.forEach { $0.removeFromSuperview() }
            gameMenUtil.gamesViews.removeAll()
            webView.load(URLRequest(url: u))
           NotificationCenter.default.post(name: Notification.Name("HIDE_N"), object: nil, userInfo: nil)
        } else {
            if webView.canGoBack {
                webView.goBack()
            }
        }
    }

    func refresh() {
       webView.reload()
    }
}

