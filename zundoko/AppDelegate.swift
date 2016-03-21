//
//  AppDelegate.swift
//  zundoko
//
//  Created by Watanabe Toshinori on 3/22/16.
//  Copyright © 2016 Watanabe Toshinori. All rights reserved.
//

import Cocoa

enum ZundokoType: Int {
    case Zun = 0
    case Doko
    
    func image() -> NSImage {
        switch self {
        case .Zun:
            return NSImage(named: "zun")!
        case .Doko:
            return NSImage(named: "doko")!
        }
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var shortcutView: MASShortcutView!
    
    @IBOutlet weak var statusBarMenu: NSMenu!
    
    var statusItem: NSStatusItem!
    
    var zunCounter = 0
    
    var isShowKisyoshi = false
    
    // MARK: - Initialize
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Add icon to statsu bar
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.image = NSImage(named: "StatusMenuIcon")
        statusItem.menu = statusBarMenu
        statusItem.highlightMode = true
        
        let key = "CustomShortcutKey"
        shortcutView.associatedUserDefaultsKey = key
        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(key, toAction: { [unowned self] () -> Void in
            // ズンドコキヨシ
            if self.isShowKisyoshi {
                self.isShowKisyoshi = false
             
                Zundoko(NSImage(named: "kiyoshi")!)
                return
            }
            
            let zundoko = ZundokoType(rawValue: Int(arc4random_uniform(2)))!

            switch zundoko {
            case .Zun:
                self.zunCounter += 1
            case .Doko:
                if self.zunCounter >= 4 {
                    self.isShowKisyoshi = true
                }

                self.zunCounter = 0
            }
            
            Zundoko(zundoko.image())
        })
    }
    
    // MARK: - Action
    
    @IBAction func showPreferenceWindow(sender: AnyObject) {
        window.makeKeyAndOrderFront(self)
    }
    
}

