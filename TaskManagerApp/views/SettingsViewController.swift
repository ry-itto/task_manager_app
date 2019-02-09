//
//  SettingsViewController.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/02/08.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    
    let CELL_IDENTIFIER: String = "settingCell"
    let cellTitles: [String] = ["Google認証"]
    
    static func createWithTabItem() -> UINavigationController {
        let navigationController: UINavigationController = UINavigationController(rootViewController: SettingsViewController())
        navigationController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(named: "setting"), tag: 1)
        return navigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "設定"
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    // セクションごとに何個のセルを表示するか決めるメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    // 各セルの高さを設定するメソッド
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 各セルに対しての設定をするメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        tableCell.textLabel?.text = cellTitles[indexPath.row]
        
        return tableCell
    }
    
    // セルがタップされた時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        navigationController?.pushViewController(GoogleSettingViewController(), animated: true)
    }
}
