//
//  ViewController.swift
//  reign_test_
//
//  Created by Daniel Verdugo Gonzalez on 16-08-21.
//

import UIKit
class IntroViewController: UIViewController {

    @IBAction func GoToHome(_ sender: Any) {
        
        
        
        let tabViewController = HomeViewController()//RegisterNewActivity
        tabViewController.hidesBottomBarWhenPushed=false
        tabViewController.modalPresentationStyle = .fullScreen
        self.present(tabViewController, animated: true, completion: nil)

  
        
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    

}



