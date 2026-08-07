//
//  ViewController.swift
//  go-saffe-swift
//
//  Created by Pedro Cruz on 08/01/2024.
//  Copyright (c) 2024 Pedro Cruz. All rights reserved.
//

import UIKit
import go_saffe_swift

struct ExampleSettings: Settings {
    var primaryColor: String?
    var secondaryColor: String?
    var lang: String?
}

struct ExampleExtraData: ExtraData {
    var settings: Settings?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let extraData = ExampleExtraData(
            settings: ExampleSettings(
                primaryColor: "#00ABAB",
                secondaryColor: "#6A6A6A",
                lang: "en"
            )
        )

        let goSaffeCapture = GoSaffeCapture(
            captureKey: "your-capture-key",
            user: "example@email.com",
            type: "verification",
            endToEndId: "exampleEndToEndId",
            onClose: {
                print("Capture closed")
            },
            onFinish: {
                print("Capture finished")
            },
            onTimeout: {
                print("Capture timed out")
            },
            extraData: extraData
        )
                
        self.present(goSaffeCapture, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
