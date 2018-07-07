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
    private var keyDeltaY: CGFloat = 15;

    private var keyMouseDeltaY: CGFloat = 5;

    private let initHeight: CGFloat = 100;

    private var screenSize: CGSize = CGSize(width: 0, height: 0);

    enum KeyType
    {
        case none
        case down
        case up
        case reset
    }

    func getKeyType(key: String)->KeyType
    {
        switch key {
            case "j":

                return KeyType.down;
            case "k":

                return KeyType.up;
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
            self.scrollWheel(with: event)

            return event
        }

        resetWindow();
    }

    override func viewWillAppear()
    {
        super.viewWillAppear();

        self.view.window?.hasShadow                  = false;
        self.view.window?.titlebarAppearsTransparent = true;
        self.view.window?.titleVisibility            = .hidden;
        self.view.window?.styleMask                  = .fullSizeContentView;

        self.screenSize = NSScreen.main!.frame.size;

        self.view.window?.level = .floating
    }

    override func keyDown(with event : NSEvent)
    {
        let key       = String(describing: event.characters!);
        let direction = getKeyType(key: key);

        switch direction
        {
            case KeyType.down:
                resizeWindow(deltaY: -self.keyDeltaY);
            case KeyType.up:
                resizeWindow(deltaY: self.keyDeltaY);
            case KeyType.reset:

                resetWindow();
            default:

                return;
        }
    }

    override func scrollWheel(with event : NSEvent)
    {
        resizeWindow(deltaY: event.deltaY * self.keyMouseDeltaY);
    }

    func resizeWindow(deltaY : CGFloat)
    {
        let frame = self.view.window!.frame;
        self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY + deltaY, width: frame.width, height: frame.height - deltaY), display: true)
    }

    func resetWindow()
    {
        self.view.window?.setFrame(NSRect(x: 0, y: self.screenSize.height - self.initHeight, width: self.screenSize.width, height: self.initHeight), display: true)
    }
}
