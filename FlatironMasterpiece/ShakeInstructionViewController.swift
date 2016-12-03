//
//  ShakeInstructionViewController.swift
//  FlatironMasterpiece
//
//  Created by Erica Millado on 11/22/16.
//  Copyright © 2016 Elias Miller. All rights reserved.
//

import UIKit

class ShakeInstructionViewController: UIViewController {
 
    var shakeView: ShakeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        self.title = "Shake"
    }

    override func loadView() {
        super.loadView()
        shakeView = ShakeView()
        self.view = shakeView
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            print("shaken")
            
            //TODO: 1) segue to deck view 2) have the phone vibrate/pulsate 3) shaking sounds
            let deckView = CardViewController()
            self.navigationController?.pushViewController(deckView, animated: false)
        }
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
