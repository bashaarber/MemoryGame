//
//  GameController.swift
//  MemoryGame
//
//  Created by Arber Basha on 6.2.20.
//  Copyright © 2020 Arber Basha. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class GameController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var Player: UILabel!
    @IBOutlet weak var Player2: UILabel!
    @IBOutlet weak var timer2: UILabel!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var downArrow2: UIImageView!
    @IBOutlet weak var startGame: UIButton!
    
    var counter = 0
    var time = Timer()
    var player = ""
    var time2 = Timer()
    var player2 = ""
    var points: Int = 0
    var points2: Int = 0
    var multiplayer: Bool = false
    var playing: Int = 1
    var level: level = .medium
    var highscore: Int = 0
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    let game = MemoryGame()
    var cards = [Card]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if multiplayer{
            Player2.isHidden = false
            timer2.isHidden = false
            Player2.text = player2
            timer2.text = "0"
            timer.text = "0"
        }
        Player.text = player
        
        game.delegate = self
    
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        
        getCardImages(level: level)
        
        register()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            resetGame()
        }
    }
    
    func register(){
        NotificationCenter.default.addObserver(self, selector: #selector(changePlayer(_:)), name: NSNotification.Name(rawValue: "changePlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addPoints(_:)), name: NSNotification.Name(rawValue: "addPoints"), object: nil)
    }
    
    func setupNewGame() {
        cards = game.newGame(cardsArray: self.cards)
        collectionView.reloadData()
    }
    
    func resetGame() {
        game.restartGame()
        setupNewGame()
    }
    
    func getCardImages(level: level ){
        var cardImages: [UIImage] = []
        var urlArray:[String] = []
        
        switch level {
        case .easy:
            urlArray = APIFlickr.easyUrl
        case .medium:
            urlArray = APIFlickr.normalUrl
        case .hard:
            urlArray = APIFlickr.hardUrl
        }
        
        for url in urlArray{
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    cardImages.append(image)
                    self.setCardImages(cardImages: cardImages)
                }
            }
        }
        
        
    }
    
    func setCardImages(cardImages: [UIImage]){
        var cards1 = CardsArray()
        
        for image in cardImages {
            let card = Card(image: image)
            let copy = card.copy()
            
            cards1.append(card)
            cards1.append(copy)
        }
        self.cards = cards1
        self.setupNewGame()
    }
    
    // MARK: - HighScore
    func highScorePoints(level: level){
        switch level {
        case .easy:
            highscore = Highscore.easyHighscore(counter: counter)
            print("easy \(highscore)")
        case .medium:
            highscore = Highscore.normalHighscore(counter: counter)
            print("medium \(highscore)")
        case .hard:
            highscore = Highscore.hardHighscore(counter: counter)
            print("hard \(highscore)")
        }
    }
    
    func saveHighScore(name: String, highscore: Int, level: level){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = appDelegate?.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "HighscoreList", in: context!)
        
        let highscorePoints = NSManagedObject(entity: entity!, insertInto: context)
        
        highscorePoints.setValue(player, forKey: "name")
        highscorePoints.setValue(highscore, forKey: "score")
        switch level {
        case .easy:
            highscorePoints.setValue("Easy", forKey: "level")
        case .medium:
            highscorePoints.setValue("Medium", forKey: "level")
        case .hard:
            highscorePoints.setValue("Hard", forKey: "level")
        }
        
        do{
            try context?.save()
            print("saved succesfully")
        }
        catch{
            print("saving failed")
        }
        
    }
    // MARK: - Multiplayer Functionality
    @objc func changePlayer(_ notification:Notification) {
        
        if playing == 1 {
            downArrow.isHidden = true
            downArrow2.isHidden = false
            Player2.textColor = .systemBlue
            timer2.textColor = .systemBlue
            Player.textColor = .gray
            timer.textColor = .gray
            
            playing = 2
        }else{
            downArrow.isHidden = false
            downArrow2.isHidden = true
            Player.textColor = .systemBlue
            timer.textColor = .systemBlue
            Player2.textColor = .gray
            timer2.textColor = .gray
            
            playing = 1
        }
    }
    
    @objc func addPoints(_ notification:Notification) {
        
        if playing == 1 {
            points += 1
            timer.text = "\(points)"
        }else{
            points2 += 1
            timer2.text = "\(points2)"
        }
    }
    
    func getWinner()-> Int{
        if points > points2{
            return 1
        }
        if points2 > points{
            return 2
        }
        if points == points2{
            return 0
        }
        return 0
    }
    
    
    
    // MARK: - IBAction
    @IBAction func onCancel(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Cancel",
            message: "Do you want to cancel the game?",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        let playAgainAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (action) in
            
            self?.resetGame()
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)
        
        self.present(alertController, animated: true) {
        }
    }
    
    @IBAction func onStartGame(_ sender: Any) {
        collectionView.isHidden = false
        startGame.setTitle("Restart", for: .normal)
        if startGame.titleLabel?.text == "Restart"{
            resetGame()
        }
        if multiplayer{
            points = 0
            points2 = 0
            timer2.text = "0"
            timer.text = "0"
            downArrow.isHidden = false
            downArrow2.isHidden = true
            Player2.textColor = .gray
            timer2.textColor = .gray
            Player.textColor = .systemBlue
            timer.textColor = .systemBlue
        }else{
            counter = 0
            timer.text = "00:00"
            
            time.invalidate()
            time = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(timerAction),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    @objc func timerAction() {
        counter += 1
        timer.text = timeString(time: TimeInterval(counter))
    }
    
    
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

// MARK: - CollectionView Delegate Methods
extension GameController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.showCard(false, animted: false)
        
        guard let card = game.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.shown { return }
        game.didSelectCard(cell.card, multiplayer: multiplayer)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
}

// MARK: - MemoryGameProtocol Methods
extension GameController: MemoryGameProtocol {
    
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }
    
    func memoryGame(_ game: MemoryGame, showCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(true, animted: true)
        }
    }
    
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(false, animted: true)
        }
    }
    
    func memoryGameDidEnd(_ game: MemoryGame) {
        time.invalidate()
        startGame.setTitle("Play", for: .normal)
        highScorePoints(level: level)
        var message = "Your Score: \(highscore)"
        
        if multiplayer{
            let result = getWinner()
            if result == 1{
                message = "\(player) Won"
            }
            if result == 2{
                message = "\(player2) Won"
            }
            if result == 0{
                message = "Draw"
            }
        }
        
        let alertController = UIAlertController(
            title: "Want to play again?",
            message: message,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] (action) in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let playAgainAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (action) in
            self?.collectionView.isHidden = true
            self?.resetGame()
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)
        
        self.present(alertController, animated: true) {
            if !self.multiplayer{
                self.saveHighScore(name: self.player, highscore: self.highscore, level: self.level)
            }
        }
        
        resetGame()
    }
}

extension GameController: UICollectionViewDelegateFlowLayout {
    
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


