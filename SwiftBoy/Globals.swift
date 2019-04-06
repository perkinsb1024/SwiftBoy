//
//  Globals.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 10/12/18.
//  Copyright © 2018 perkinsb1024. All rights reserved.
//

import Foundation


let flowControlNotificationName = NSNotification.Name("FlowControlNotification")
let updateDebuggerNotificationName = NSNotification.Name("UpdateDebuggerNotification")
let emulatorDelayChangeNotificationName = NSNotification.Name("EmulatorDelayChangeNotification")

enum FlowControlAction {
    case Stop
    case Step
    case Run
}
