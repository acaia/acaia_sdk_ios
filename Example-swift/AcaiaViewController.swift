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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _selectModeButton.isHidden = true
        AcaiaManager.shared().enableBackgroundRecovery = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _addAcaiaEventsObserver()
        _updateScaleStatusUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        _updateScaleStatusUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _removeAcaiaEventsObserver()
    }

    
    // MARK: Private
    
    private var _isTimerStarted: Bool = false
    private var _isTimerPaused: Bool = false
    
    @IBOutlet private weak var _scanScaleButton: UIButton!
    @IBOutlet private weak var _selectModeButton: UIButton!
    
    @IBOutlet private weak var _scaleNameLabel: UILabel!
    @IBOutlet private weak var _weightLabel: UILabel!
    @IBOutlet private weak var _timerLabel: UILabel!
    
    @IBOutlet private weak var _toolView: UIView!
    @IBOutlet private weak var _timerButton: UIButton!
    @IBOutlet private weak var _pauseTimerButton: UIButton!
    @IBOutlet private weak var _disconnectButton: UIButton!
    @IBOutlet private weak var _tareButton: UIButton!
    
    private func _updateScaleStatusUI() {
        if let scale = AcaiaManager.shared().connectedScale {
            _scaleNameLabel.text = scale.name;
            _toolView.isHidden = false;
        } else {
            _toolView.isHidden = true;
            _scaleNameLabel.text = "-";
            _timerLabel.text = "-";
            _weightLabel.text = "-";
        }
    }
}


// MARK: Observe acaia events
extension AcaiaViewController {

    private func _addAcaiaEventsObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onConnect(noti:)),
                                               name: NSNotification.Name(rawValue: AcaiaScaleDidConnected),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onDisconnect(noti:)),
                                               name: NSNotification.Name(rawValue: AcaiaScaleDidDisconnected),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onWeight(noti:)),
                                               name: NSNotification.Name(rawValue: AcaiaScaleWeight),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onTimer(noti:)),
                                               name: NSNotification.Name(rawValue: AcaiaScaleTimer),
                                               object: nil)
    }
    
    private func _removeAcaiaEventsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: Acaia events
extension AcaiaViewController {
 
    @objc private func _onConnect(noti: NSNotification) {
        _updateScaleStatusUI()
    }
    @objc private func _onFailed(noti: NSNotification) {
        _updateScaleStatusUI()
    }
    
    @objc private func _onDisconnect(noti: NSNotification) {
        _updateScaleStatusUI()
    }
    
    @objc private func _onWeight(noti: NSNotification) {
        let unit = noti.userInfo![AcaiaScaleUserInfoKeyUnit]! as! NSNumber
        let weight = noti.userInfo![AcaiaScaleUserInfoKeyWeight]! as! Float
    
        if unit.intValue == AcaiaScaleWeightUnit.gram.rawValue {
            _weightLabel.text = String(format: "%.1f g", weight)
        } else {
            _weightLabel.text = String(format: "%.4f oz", weight)
        }
    }
    
    @objc private func _onTimer(noti: NSNotification) {
        guard let time = noti.userInfo?["time"] as? Int else { return }
        _timerLabel.text = String(format: "%02d:%02d", time/60, time%60)
        _isTimerStarted = true;
    }
}


// MARK: IBActions
extension AcaiaViewController {
    
    @IBAction private func _onBtnTimer() {
        if let scale = AcaiaManager.shared().connectedScale {
            if _isTimerStarted {
                _isTimerStarted = false;
                _isTimerPaused = false;
                scale.stopTimer()
                _pauseTimerButton.isEnabled = false;
                _timerButton.setTitle("Start Timer", for: UIControl.State.normal)
                _pauseTimerButton.setTitle("Pause Timer", for: UIControl.State.normal)
                _timerLabel.text = "-";
            } else {
                _pauseTimerButton.isEnabled = true;
                scale.startTimer()
                _timerButton.setTitle("Stop Timer", for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction private func _onBtnPauseTimer() {
        if let scale = AcaiaManager.shared().scaleList.first {
            if _isTimerPaused {
                _isTimerPaused = false
                scale.startTimer()
                _pauseTimerButton.setTitle("Pause Timer", for: UIControl.State.normal)
            } else {
                _isTimerPaused = true
                scale.pauseTimer()
                _pauseTimerButton.setTitle("Resume Timer", for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction private func _onBtnTare() {
        AcaiaManager.shared().connectedScale?.tare()
    }
    
    @IBAction private func _onBtnDisconnect() {
        AcaiaManager.shared().connectedScale?.disconnect()
    }
}
