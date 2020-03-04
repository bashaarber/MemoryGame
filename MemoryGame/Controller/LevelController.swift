//
//  LevelController.swift
//  MemoryGame
//
//  Created by Arber Basha on 6.2.20.
//  Copyright © 2020 Arber Basha. All rights reserved.
//

import UIKit

class LevelController: UIViewController {
    
    var multiplayer: Bool = false
    @IBOutlet weak var singleOrMulti: UILabel!
    @IBOutlet weak var rule: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if multiplayer{
            singleOrMulti.text = "Multiplayer"
            rule.text = "Rule: Points"
        }
        createScreenEdgeSwipe()
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEasy(_ sender: Any) {
        addName(level: .easy)
    }
    
    @IBAction func onNormal(_ sender: Any) {
        addName(level: .medium)
    }
    
    @IBAction func onHard(_ sender: Any) {
        addName(level: .hard)
    }
    
    func addName(level: level){
        
        var inputTextField: UITextField?
        var inputTextField2: UITextField?
        
        var title: String = ""
        
        if multiplayer{
            title = "Add Players Name"
        }else{
            title = "Name"
        }
        
        let alertController = UIAlertController(
            title: title,
            message: "",
            preferredStyle: .alert)
        
        
        let playAgainAction = UIAlertAction(title: "Start Game", style: .default) { [weak self] (action) in
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GameController") as? GameController
            if self!.multiplayer{
                vc?.player2 = inputTextField2!.text!
                vc?.player = inputTextField!.text!
                vc?.multiplayer = self!.multiplayer
            }else{
                vc?.player = inputTextField!.text!
            }
            
            vc?.level = level
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(playAgainAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) -> Void in
            if self.multiplayer{
                textField.placeholder = "Enter First Player Name"
            }else{
                textField.placeholder = "Enter Name"
            }
            
            inputTextField = textField
        }
        if multiplayer{
            alertController.addTextField { (textField) -> Void in
                textField.placeholder = "Enter Second Player Name"
                inputTextField2 = textField
            }
        }
        
        self.present(alertController, animated: true) {
            
        }
    }
    
    func createScreenEdgeSwipe(){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
    }
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
