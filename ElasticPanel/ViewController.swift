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
    private var deltaX: CGFloat = 10;

    private var deltaY: CGFloat = 10;

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
            case "c":

                return KeyType.config;
            default:

                return KeyType.none;
        }
    }

    @IBOutlet weak var xLabel: NSTextField!

    @IBOutlet weak var yLabel: NSTextField!

    @IBOutlet weak var xTextField: NSTextField!

    @IBOutlet weak var yTextField: NSTextField!

    @IBAction func onChangeX(_ sender : NSTextField)
    {
        let title:String? = sender.cell?.title;
        UserDefaults.standard.setValue(title!, forKey: "delta_x");

        self.deltaX = strToCGFloat(str: title!);
    }

    @IBAction func onChangeY(_ sender : NSTextField)
    {
        let title : String? = sender.cell?.title;
        UserDefaults.standard.setValue(title!, forKey: "delta_y");

        self.deltaY = strToCGFloat(str: title!);
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        NSEvent.addLocalMonitorForEvents(matching:.keyDown) {
            (event)->NSEvent? in
            self.keyDown(with : event)

            return event
        }

        if UserDefaults.standard.object(forKey : "delta_x") == nil
        {
            UserDefaults.standard.setValue(self.deltaX, forKey: "delta_x");
        }

        if UserDefaults.standard.object(forKey: "delta_y") == nil
        {
            UserDefaults.standard.setValue(self.deltaY, forKey: "delta_y");
        }

        if UserDefaults.standard.object(forKey: "hide_config") == nil
        {
            UserDefaults.standard.setValue(false, forKey: "hide_config");
        }

        let deltaX : String = UserDefaults.standard.string(forKey: "delta_x")!;
        let deltaY : String = UserDefaults.standard.string(forKey: "delta_y")!;
        self.xTextField.cell?.title = deltaX;
        self.yTextField.cell?.title = deltaY;
        self.deltaX                   = strToCGFloat(str: deltaX);
        self.deltaY                   = strToCGFloat(str: deltaY);

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

        resizeWindow(direction: direction);
    }

    func resizeWindow(direction : KeyType)
    {
        let frame = self.view.window!.frame;

        switch direction
        {
            case KeyType.left:
                self.view.window?.setFrame(NSRect(x: frame.minX - self.deltaX, y: frame.minY, width: frame.width + self.deltaX, height: frame.height), display: true)
            case KeyType.down :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY - self.deltaY, width: frame.width, height: frame.height + self.deltaY), display: true)
            case KeyType.up :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height + self.deltaY), display: true)
            case KeyType.right :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY, width: frame.width + self.deltaX, height: frame.height), display: true)
            case KeyType.reset :

                self.view.window?.setFrame(NSRect(x: 0, y: self.screenSize.height - self.initHeight, width: self.screenSize.width, height: self.initHeight), display: true)
            case KeyType.config :
                let hideConfig = UserDefaults.standard.bool(forKey: "hide_config");
                UserDefaults.standard.setValue(!hideConfig, forKey: "hide_config");
                updateConfig();
            default:

                return;
        }
    }

    func updateConfig()
    {
        let hideConfig = UserDefaults.standard.bool(forKey:"hide_config");
        self.xLabel.isHidden     = hideConfig;
        self.yLabel.isHidden     = hideConfig;
        self.xTextField.isHidden = hideConfig;
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
