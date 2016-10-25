//
//  ViewController.swift
//  DE_HeartFlyEffect
//
//  Created by go.yaro on 10/25/16.
//  Copyright © 2016 DDDrop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let hfv = HeartFlyView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        hfv.center = self.view.center

        self.view.addSubview(hfv)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

