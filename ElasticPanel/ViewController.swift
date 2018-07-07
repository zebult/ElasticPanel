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
    private var keyDeltaY: CGFloat = 10;

    private var keyMouseDeltaY: CGFloat = 5;

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
        case config
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
            case "c":

                return KeyType.config;
            default:

                return KeyType.none;
        }
    }

    @IBOutlet weak var yLabel: NSTextField!

    @IBOutlet weak var yTextField: NSTextField!

    @IBAction func onChangeY(_ sender : NSTextField)
    {
        let title:String? = sender.cell?.title;
        UserDefaults.standard.setValue(title!, forKey: "delta_y");

        self.keyDeltaY = strToCGFloat(str: title!);
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

        if UserDefaults.standard.object(forKey : "delta_y") == nil
        {
            UserDefaults.standard.setValue(self.keyDeltaY, forKey: "delta_y");
        }

        if UserDefaults.standard.object(forKey: "hide_config") == nil
        {
            UserDefaults.standard.setValue(false, forKey: "hide_config");
        }

        let deltaY : String = UserDefaults.standard.string(forKey: "delta_y")!;
        self.yTextField.cell?.title = deltaY;
        self.keyDeltaY                = strToCGFloat(str: deltaY);

        resetWindow();
        updateConfig();
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

        switch direction
        {
            case KeyType.down:
                resizeWindow(deltaY: -self.keyDeltaY);
            case KeyType.up:
                resizeWindow(deltaY: self.keyDeltaY);
            case KeyType.reset:

                resetWindow();
            case KeyType.config:
                let hideConfig = UserDefaults.standard.bool(forKey:"hide_config");
                UserDefaults.standard.setValue(!hideConfig, forKey: "hide_config");
                updateConfig();
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

    func updateConfig()
    {
        let hideConfig = UserDefaults.standard.bool(forKey:"hide_config");
        self.yLabel.isHidden     = hideConfig;
        self.yTextField.isHidden = hideConfig;
    }

    func strToCGFloat(str : String)->CGFloat
    {
        if let number = NumberFormatter().number(from: str)
        {
            return CGFloat(truncating: number);
        }

        return 0;
    }
}
