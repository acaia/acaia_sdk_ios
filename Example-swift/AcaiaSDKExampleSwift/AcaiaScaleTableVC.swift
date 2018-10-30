//
//  AcaiaScaleTableVC.swift
//  AcaiaSDKExampleSwift
//
//  Created by Michael Wu on 2018/7/4.
//  Copyright © 2018 acaia Corp. All rights reserved.
//

import UIKit
import AcaiaSDK
import MBProgressHUD

class AcaiaScaleTableVC: UITableViewController {

    var isRefreshed:Bool = false
    var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isRefreshed = false
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Scaning")
        self.tableView.refreshControl = self.refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(onConnect), name: Notification.Name(rawValue: AcaiaScaleDidConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onFinishScan), name: Notification.Name(rawValue: AcaiaScaleDidFinishScan), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isRefreshed == false {
            self.isRefreshed = true
            self.tableView.refreshControl?.beginRefreshing()
            self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-self.refreshControl!.frame.size.height), animated: true)
            
        }
        AcaiaManager.shared().startScan(5.0)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refresh(_ sender: Any) {
        AcaiaManager.shared().startScan(5.0)
    }
    
    @objc func onConnect() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.navigationController?.popViewController(animated: true)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func onFinishScan() {
        self.tableView.refreshControl?.endRefreshing();
        if AcaiaManager.shared().scaleList.count > 0 {
            self.tableView.reloadData()
        }
    }
    
    @objc func onTimer(_ timer: Timer) {
        MBProgressHUD.hide(for: self.view, animated: false)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AcaiaManager.shared().scaleList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScaleCell", for: indexPath)

        if let scale = AcaiaManager.shared().scaleList?[indexPath.row] as? AcaiaScale{
            cell.textLabel?.text = scale.name
            cell.detailTextLabel?.text = scale.uuid
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(onTimer(_:)), userInfo: nil, repeats: false)
        if let scale = AcaiaManager.shared().scaleList?[indexPath.row] as? AcaiaScale{
            scale.connect()
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = String(format:"Connecting to %@", scale.name)
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

