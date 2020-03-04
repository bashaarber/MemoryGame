//
//  MainController.swift
//  MemoryGame
//
//  Created by Arber Basha on 6.2.20.
//  Copyright © 2020 Arber Basha. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    @IBAction func onSinglePlayer(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LevelController") as? LevelController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func onMultiplayer(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LevelController") as? LevelController
        vc?.multiplayer = true
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func onHighscore(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HighscoreController") as? HighscoreController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
