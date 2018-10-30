//
//  AcaiaViewController.swift
//  AcaiaSDKExampleSwift
//
//  Created by Michael Wu on 2018/7/4.
//  Copyright © 2018 acaia Corp. All rights reserved.
//

import UIKit
import AcaiaSDK

class AcaiaViewController: UIViewController {
    @IBOutlet var scaleNameL: UILabel!
    @IBOutlet var weightL: UILabel!
    @IBOutlet var timerL: UILabel!
    @IBOutlet var toolView: UIView!
    @IBOutlet var btnTimer: UIButton!
    @IBOutlet var btnPauseTimer: UIButton!
    @IBOutlet var btnDisconnect: UIButton!
    @IBOutlet var btnTare: UIButton!
    var isTimerStarted:Bool = false;
    var isTimerPaused:Bool = false;
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(onConnect(noti:)), name: NSNotification.Name(rawValue: AcaiaScaleDidConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onFailed(noti:)), name: NSNotification.Name(rawValue: AcaiaScaleConnectFailed), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDisconnect(noti:)), name: NSNotification.Name(rawValue: AcaiaScaleDidDisconnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onWeight(noti:)), name: NSNotification.Name(rawValue: AcaiaScaleWeight), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTimer(noti:)), name: NSNotification.Name(rawValue: AcaiaScaleTimer), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    @objc func onConnect(noti: NSNotification) {
        self.refreshUI()
    }
    @objc func onFailed(noti: NSNotification) {
        self.refreshUI()
    }
    
    @objc func onDisconnect(noti: NSNotification) {
        self.refreshUI()
    }
    
    @objc func onWeight(noti: NSNotification) {
        let unit = noti.userInfo![AcaiaScaleUserInfoKeyUnit]! as! NSNumber
        let weight = noti.userInfo![AcaiaScaleUserInfoKeyWeight]! as! Float
        if unit.intValue == AcaiaScaleWeightUnit.gram.rawValue {
            self.weightL.text = String(format: "%.1f g", weight)
        } else {
            self.weightL.text = String(format: "%.4f oz", weight)
        }
    }
    
    @objc func onTimer(noti: NSNotification) {
        let time = noti.userInfo![AcaiaScaleUserInfoKeyTimer] as! Int
        self.timerL.text = String(format: "%02d:%02d", time/60, time%60)
        self.isTimerStarted = true;
    }
    
    func refreshUI() {
        if let scale = AcaiaManager.shared().connectedScale {
            self.scaleNameL.text = scale.name;
            self.toolView.isHidden = false;
        } else {
            self.toolView.isHidden = true;
            self.scaleNameL.text = "-";
            self.timerL.text = "-";
            self.weightL.text = "-";
        }
    }
    @IBAction func onBtnTimer() {
        if let scale = AcaiaManager.shared().connectedScale {
            if self.isTimerStarted {
                self.isTimerStarted = false;
                self.isTimerPaused = false;
                scale.stopTimer()
                self.btnPauseTimer.isEnabled = false;
                self.btnTimer.setTitle("Start Timer", for: UIControl.State.normal)
                self.btnPauseTimer.setTitle("Pause Timer", for: UIControl.State.normal)
                self.timerL.text = "-";

            } else {
                self.btnPauseTimer.isEnabled = true;
                scale.startTimer()
                self.btnTimer.setTitle("Stop Timer", for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction func onBtnPauseTimer() {
        if let scale = AcaiaManager.shared().connectedScale {
            if self.isTimerPaused {
                self.isTimerPaused = false
                scale.startTimer()
                self.btnPauseTimer.setTitle("Pause Timer", for: UIControl.State.normal)
            } else {
                self.isTimerPaused = true
                scale.pauseTimer()
                self.btnPauseTimer.setTitle("Resume Timer", for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction func onBtnTare() {
        if let scale = AcaiaManager.shared().connectedScale {
            scale.tare()
        }
    }
    
    @IBAction func onBtnDisconnect() {
        if let scale = AcaiaManager.shared().connectedScale {
            scale.disconnect()
        }
    }
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
