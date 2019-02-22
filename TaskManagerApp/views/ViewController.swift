//
//  ViewController.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/01/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView?
    @IBOutlet var registerButton: UIButton?
    
    let CELL_IDENTIFIER = "cell"
    let taskReposiory: TaskRepository = TaskRepository.sharedInstance
    var tasks: Array<Task> = []
    
    static func createWithTabBarItem() -> UINavigationController {
        let viewController = UINavigationController(rootViewController: ViewController())
        viewController.tabBarItem = UITabBarItem(title: "タスク管理", image: UIImage(named: "todoList"), tag: 0)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let table = tableView else { return }
        
        // ビューのタイトルを設定し，ナビゲーションバーに表示させる
        title = "タスク一覧"
        
        // 追加ボタンのUI設定
        registerButton?.backgroundColor = UIColor(hex: "00adb5")
        registerButton?.setTitleColor(.white, for: .normal)
        registerButton?.layer.shadowOffset = CGSize(width: 2, height: 2)
        registerButton?.layer.shadowColor = UIColor.gray.cgColor
        registerButton?.layer.shadowRadius = 5
        registerButton?.layer.shadowOpacity = 1.0
        
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        
        // セルを登録する
        table.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tasks = taskReposiory.findAllTask()
        tableView?.reloadData()
    }
    
    // 「追加」ボタンがタップされた時の処理
    @IBAction func didAddButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "00adb5")
        let registerView: TaskFormController = TaskFormController(task: Task(), buttonTitle: "登録")
        registerView.title = "タスク登録"
        registerView.delegate = self
        present(registerView, animated: true, completion: nil)
    }
    
    // ボタンを押している間のイベント
    @IBAction func addButtonIsTapping(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "009da4")
    }
    
    // ボタンがタップされ，ボタンの外側で放された(キャンセルされた)時のイベント
    @IBAction func didAddButtonTappedOutside(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "00adb5")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // セクションごとに何個のセルを表示するか決めるメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // 各セルの高さを設定するメソッド
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 各セルに対しての設定をするメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        tableCell.textLabel?.text = tasks[indexPath.row].title
        
        if tasks[indexPath.row].checked {
            tableCell.imageView?.image = UIImage(named: "checked")
        } else {
            tableCell.imageView?.image = UIImage(named: "unchecked")
        }
        
        return tableCell
    }
    
    // テーブルが編集モードになった時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // テーブルの削除などをする時に以下のメソッドが必要
            tableView.beginUpdates()
            taskReposiory.deleteTask(task: tasks[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            // テーブルを更新した時にnumberOfRowsInSectionから返る値も変える必要があるため，tasksを更新
            tasks = TaskRepository.sharedInstance.findAllTask()
            tableView.endUpdates()
        }
    }
    
    // セルがタップされた時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // 日付を文字列にするためのフォーマット作成
        let df = DateFormatter()
        df.dateStyle = .long
        df.locale = Locale(identifier: "ja")
        
        // 登録，編集画面を初期化
        let registerView: TaskFormController = TaskFormController(task: tasks[indexPath.row], buttonTitle: "更新")
        registerView.title = "タスク編集"

        registerView.delegate = self
        present(registerView, animated: true, completion: nil)
    }
}

extension ViewController: TaskFormControllerDelegate {
    func taskFormControllerDidTapCancel(_ taskFormController: TaskFormController) {
        taskFormController.dismiss(animated: true, completion: nil)
    }
}
