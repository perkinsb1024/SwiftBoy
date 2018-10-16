//
//  RegisterViewController.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 4/15/17.
//  Copyright © 2017 perkinsb1024. All rights reserved.
//

import Cocoa

class RegisterViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet var registerController: NSDictionaryController!
    dynamic var testDict: NSMutableDictionary = ["a": "test"]
    override func viewDidLoad() {
        super.viewDidLoad()
        registerController.content = testDict
    }
}
