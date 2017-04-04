//
//  DetailVC.swift
//  MapDemo
//
//  Created by Zeitech Solutions on 29/03/17.
//  Copyright © 2017 Bansi. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet var lblAddress : UILabel!
    var lblText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        
        if(lblText.characters.count > 0){
        lblAddress?.text = lblText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
