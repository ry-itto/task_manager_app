//
//  ViewController.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/01/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView?
    
    let CELL_IDENTIFIER = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let table = tableView else { return }
        // Do any additional setup after loading the view, typically from a nib.
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
    }
    
    @IBAction func didAddButtonTupped(_ sender: UIButton) {
        let registerView: RegisterViewController = RegisterViewController()
        navigationController?.pushViewController(registerView, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        // 3で割り切れる時に数字を入れて，そうでない時に空文字を入れて更新する処理
        tableCell.textLabel?.text = indexPath.row % 3 == 0 ? "\(indexPath.row)" : ""
        
        return tableCell
    }
}

