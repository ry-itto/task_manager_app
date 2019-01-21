//
//  ViewController.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/01/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView?
    @IBOutlet var registerButton: UIButton?
    
    let CELL_IDENTIFIER = "cell"
    var realm: Realm?
    var tasks: Array<Task>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let table = tableView else { return }
        
        do {
            let config = Realm.Configuration(schemaVersion: 2)
            Realm.Configuration.defaultConfiguration = config
            // Realm初期化
            try realm = Realm()
            guard let t = realm?.objects(Task.self) else { return }
            tasks = Array(t)
        } catch {
            print("Failed : Realm initialize")
        }
        
        // ビューのタイトルを設定し，ナビゲーションバーに表示させる
        title = "タスク一覧"
        
        // 追加ボタンのUI設定
        registerButton?.backgroundColor = UIColor(hex: "00adb5")
        registerButton?.setTitleColor(UIColor(hex: "222831"), for: .normal)
        
        // デリゲートを設定
        table.delegate = self
        
        // データソースを設定
        table.dataSource = self
        
        // セルを登録する
        table.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 以下ビュー自体のリロード処理
        loadView()
        viewDidLoad()
    }
    
    // 「追加」ボタンがタップされた時の処理
    @IBAction func didAddButtonTupped(_ sender: UIButton) {
        let registerView: RegisterViewController = RegisterViewController()
        registerView.title = "タスク登録"
        navigationController?.pushViewController(registerView, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // セクションごとに何個のセルを表示するか決めるメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    // 各セルの高さを設定するメソッド
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 各セルに対しての設定をするメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        tableCell.textLabel?.text = tasks?[indexPath.row].title
        
        guard let checked = tasks?[indexPath.row].checked else { return tableCell }
        
        if checked {
            tableCell.imageView?.image = UIImage(named: "checked")
        } else {
            tableCell.imageView?.image = UIImage(named: "unchecked")
        }
        
        return tableCell
    }
    
    // テーブルが編集モードになった時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try realm?.write {
                    // テーブルの削除などをする時に以下のメソッドが必要
                    tableView.beginUpdates()
                    realm?.delete((tasks?[indexPath.row])!)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch {
                print("Failed : delete record")
            }
        }
        // テーブルを更新した時にnumberOfRowsInSectionから返る値も変える必要があるため，tasksを更新
        guard let t = realm?.objects(Task.self) else { return }
        tasks = Array(t)
        tableView.endUpdates()
    }
    
    // セルがタップされた時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let targetTask = tasks?[indexPath.row] else { return }
        
        // 日付を文字列にするためのフォーマット作成
        let df = DateFormatter()
        df.dateStyle = .long
        df.locale = Locale(identifier: "ja")
        
        // 登録，編集画面を初期化
        let registerView: RegisterViewController = RegisterViewController()
        registerView.title = "タスク編集"
        registerView.registerButton?.setTitle("更新", for: .normal)
        registerView.task = targetTask
        
        navigationController?.pushViewController(registerView, animated: true)
    }
}
