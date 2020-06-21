//
//  AcaiaScaleTableVC.swift
//  AcaiaSDKExampleSwift
//
//  Created by Michael Wu on 2018/7/4.
//  Copyright © 2018 acaia Corp. All rights reserved.
//

import UIKit
import MBProgressHUD
import AcaiaSDK


class AcaiaScaleTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onConnect),
                                               name: Notification.Name(rawValue: AcaiaScaleDidConnected),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onFinishScan),
                                               name: Notification.Name(rawValue: AcaiaScaleDidFinishScan),
                                               object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AcaiaManager.shared().startScan(0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AcaiaManager.shared().scaleList.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScaleCell", for: indexPath)

        let scale = AcaiaManager.shared().scaleList[indexPath.row]

        cell.textLabel?.text = scale.name
        cell.detailTextLabel?.text = scale.modelName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scale = AcaiaManager.shared().scaleList[indexPath.row]
        
        scale.connect()
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = String(format:"Connecting to %@", scale.name)
        
        _timer = Timer.scheduledTimer(timeInterval: 10.0,
                                      target: self,
                                      selector: #selector(onTimer(_:)),
                                      userInfo: nil,
                                      repeats: false)
    }
    
    
    // MARK: Private
    
    private var _timer: Timer? = nil
    
    @objc private func _scanListChanged(noti: NSNotification) {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    @objc private func _onConnect() {
        MBProgressHUD.hide(for: view, animated: true)
        navigationController?.popViewController(animated: true)
        _timer?.invalidate()
        _timer = nil
    }
    
    @objc private func onFinishScan() {
        tableView.refreshControl?.endRefreshing();
        if AcaiaManager.shared().scaleList.count > 0 {
            tableView.reloadData()
        }
    }
    
    @objc private func onTimer(_ timer: Timer) {
        MBProgressHUD.hide(for: view, animated: false)
        _timer?.invalidate()
        _timer = nil
    }
}

