//
//  ViewController.swift
//  Chat2AppExample
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import UIKit
import Chat2App


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Chat2App.shared.setChatUser(name: "User 3", uniqId: "111")
    }
    
    @IBAction func showChatTap(_ sender: Any) {
        Chat2App.shared.presentMessenger(from: self)
    }
    

}

