//
//  ViewController.swift
//  BlinkingSnowMan
//
//  Created by Rustam Shorov on 04.12.2018.
//  Copyright © 2018 Rustam Shorov. All rights reserved.
//

import UIKit

class SnowGuyViewController: UIViewController{
    
    weak var timer = Timer()
    var isEyesOpen: Bool = true
    
    
    @IBOutlet var imageViewSnowman: Snowguy!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(blinking), userInfo: nil, repeats: true)
        blinking()
    }
    
    @objc func blinking() {
        isEyesOpen = !isEyesOpen
        imageViewSnowman.delegateOpenEyes = self
        imageViewSnowman.setNeedsDisplay()
    }
}

extension SnowGuyViewController: EyesOpeningDelegate {
    func openEyes() -> Bool {
        return isEyesOpen
    }
}
