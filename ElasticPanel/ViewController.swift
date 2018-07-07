/*
 *
 *  ViewController.swift
 *  ElasticPanel
 *
 *  Created by 鈴木 才智 on 2018/07/07.
 *  Copyright © 2018年 鈴木 才智. All rights reserved.
 *
 */

import Cocoa

class ViewController: NSViewController
{
    private let distanceX: CGFloat = 10;

    private let distanceY: CGFloat = 10;

    private let initHeight: CGFloat = 100;

    private var screenSize: CGSize = CGSize(width: 0, height: 0);

    enum KeyType
    {
        case none
        case left
        case down
        case up
        case right
        case reset
    }

    func getKeyType(key: String)->KeyType
    {
        switch key {
            case "h":

                return KeyType.left;
            case "j":

                return KeyType.down;
            case "k":

                return KeyType.up;
            case "l":

                return KeyType.right;
            case "r":

                return KeyType.reset;
            default:

                return KeyType.none;
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        NSEvent.addLocalMonitorForEvents(matching:.keyDown) {
            (event)->NSEvent? in
            self.keyDown(with : event)

            return event
        }
    }

    override func viewWillAppear()
    {
        super.viewWillAppear();

        self.view.window?.hasShadow                  = false;
        self.view.window?.titlebarAppearsTransparent = true;
        self.view.window?.titleVisibility            = .hidden;
        self.view.window?.styleMask                  = .fullSizeContentView;

        self.screenSize = NSScreen.main!.frame.size;
    }

    override func keyDown(with event : NSEvent)
    {
        let key       = String(describing: event.characters!);
        let direction = getKeyType(key: key);

        resizeWindow(direction: direction);
    }

    func resizeWindow(direction : KeyType)
    {
        let frame = self.view.window!.frame;

        switch direction
        {
            case KeyType.left:
                self.view.window?.setFrame(NSRect(x: frame.minX - self.distanceX, y: frame.minY, width: frame.width + self.distanceX, height: frame.height), display: true)
            case KeyType.down :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY - self.distanceY, width: frame.width, height: frame.height + self.distanceY), display: true)
            case KeyType.up :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height + self.distanceY), display: true)
            case KeyType.right :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY, width: frame.width + self.distanceX, height: frame.height), display: true)
            case KeyType.reset :

                self.view.window?.setFrame(NSRect(x: 0, y: self.screenSize.height - self.initHeight, width: self.screenSize.width, height: self.initHeight), display: true)
            default :

                return;
        }
    }
}
