//
//  HighscoreController.swift
//  MemoryGame
//
//  Created by Arber Basha on 7.2.20.
//  Copyright © 2020 Arber Basha. All rights reserved.
//

import UIKit
import CoreData

class HighscoreController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var highscoreArray: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataWithPredicate(level: "all")
    }
    
    
    func fetchDataWithPredicate(level: String){
        highscoreArray = []
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = appDelegate?.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighscoreList")
        if level != "all"{
            request.predicate = NSPredicate(format: "level =  %@", "\(level)")
        }
        
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        do{
            let results = try context?.fetch(request)
            for highscore in (results as? [NSManagedObject])!{
                let player = Player()
                player.name = highscore.value(forKey: "name") as! String
                player.score = highscore.value(forKey: "score") as! Int
                player.level = highscore.value(forKey: "level") as! String
                highscoreArray.append(player)
            }
        }catch{
            print("something Wrong")
        }
        tableView.reloadData()
    }
    
    // MARK: - IBAction
    @IBAction func onAll(_ sender: Any) {
        fetchDataWithPredicate(level: "all")
    }
    
    @IBAction func onEasy(_ sender: Any) {
        fetchDataWithPredicate(level: "Easy")
    }
    
    @IBAction func onNormal(_ sender: Any) {
        fetchDataWithPredicate(level: "Medium")
    }
    
    @IBAction func onHard(_ sender: Any) {
        fetchDataWithPredicate(level: "Hard")
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - TableView Delegate Methods
extension HighscoreController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if highscoreArray.count > 15{
            return 15
        }else{
            return highscoreArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighscoreCell", for: indexPath) as! HighscoreCell
        
        let playerCell = highscoreArray[indexPath.row]
        
        cell.lblName.text = "\(indexPath.row + 1). \(playerCell.name)"
        cell.lblPoints.text = "\(playerCell.score)"
        cell.lblLevel.text = playerCell.level
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.75,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    
}
