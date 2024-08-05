//
//  ViewController.swift
//  go-saffe-swift
//
//  Created by Pedro Cruz on 08/01/2024.
//  Copyright (c) 2024 Pedro Cruz. All rights reserved.
//

import UIKit
import go_saffe_swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let goSaffeCapture = GoSaffeCapture(
            captureKey: "captureKey",
            user: "",
            type: "verification",
            endToEndId: "exampleEndToEndId",
            onClose: {
                print("Capture closed")
            },
            onFinish: {
                print("Capture finished")
            }
        )
                
        self.present(goSaffeCapture, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

