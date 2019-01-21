//
//  RegisterViewController.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/01/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RealmSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet var dueDateTextField: UITextField?
    @IBOutlet var taskTitle: UITextField?
    @IBOutlet var taskContent: UITextField?
    @IBOutlet var registerButton: UIButton?
    @IBOutlet var checkButton: UIButton?
    @IBOutlet var taskCategory: UITextField?
    
    var task: Task?
    var realm: Realm?
    var dueDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let config = Realm.Configuration(schemaVersion: 3)
            Realm.Configuration.defaultConfiguration = config
            // Realm初期化，Realmファイルへのパスを標準出力
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            realm = try Realm()
            
            checkButton?.setImage(UIImage(named: "blank_checkbox"), for: .normal)
            checkButton?.setImage(UIImage(named: "checked_checkbox"), for: .selected)
        } catch {
            print("Failed : Realm initialize")
        }
        
        if task != nil {
            initializeFields()
        }
        
        taskTitle?.inputAccessoryView = createToolBar()
        
        taskContent?.inputAccessoryView = createToolBar()
        
        taskCategory?.inputView = TaskCategoryPicker(selectItems: ["aaa", "bbb"])
        
        // 期日のテキストフィールドの入力方法のビューについて設定
        dueDateTextField?.inputView = createDatePickerView()
        
        // 出てくる期日入力用ビューのツールバー部分を設定
        dueDateTextField?.inputAccessoryView = createToolBar()
        
        // 登録，編集ボタンのUI設定
        registerButton?.backgroundColor = UIColor(hex: "00adb5")
        registerButton?.setTitleColor(UIColor(hex: "222831"), for: .normal)
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 以下ビュー自体のリロード処理
        loadView()
        viewDidLoad()
    }
    
    // 登録，編集ボタンがタップされた時の処理
    @IBAction func didRegisterButtonTapped(_ sender: UIButton) {
        let numberOfTasks: Int? = realm?.objects(Task.self).count
        if task == nil {
            task = Task()
            task?.id = (numberOfTasks ?? 0) + 1
        }
        
        do {
            try realm?.write {
                task?.title = taskTitle?.text ?? ""
                task?.category = taskCategory?.text ?? ""
                task?.content = taskContent?.text ?? ""
                task?.dueDate = dueDate
                task?.checked = checkButton?.isSelected ?? false
                if realm?.object(ofType: Task.self, forPrimaryKey: task?.id) == nil {
                    realm?.add(task!)
                }
            }
        } catch {
            print("RegisterViewController#didRegisterButtonTapped")
            print("Failed : Realm write process")
        }
        (presentingViewController as? ViewController)?.tableView?.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    // ボタンが押された時の処理
    @IBAction func buttonDidTap(_ sender: UIButton) {
        checkButton?.isSelected = !sender.isSelected
    }
    
    // 画面をリロードするメソッド
    func reloadView() {
        loadView()
        viewDidLoad()
    }
    
    // DatePickerのViewを作成するメソッド
    private func createDatePickerView() -> UIDatePicker {
        let dp: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
        dp.locale = Locale.current
        dp.datePickerMode = .date
        dp.minimumDate = Date()
        dp.addTarget(self, action: #selector(setText), for: .valueChanged)
        return dp
    }
    
    // ツールバーについて設定するメソッド
    private func createToolBar() -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDoneButtonTapped))
        toolbar.setItems([doneButtonItem], animated: true)
        
        return toolbar
    }
    
    // 送られてきたTaskの値をテキストフィールドに適用します。
    private func initializeFields() {
        
        let df = DateFormatter()
        df.dateStyle = .long
        df.locale = Locale(identifier: "ja")
        
        taskTitle?.text = task?.title
        taskContent?.text = task?.content
        taskCategory?.text = task?.category
        dueDateTextField?.text = df.string(from: (task?.dueDate)!)
        checkButton?.isSelected = task?.checked ?? false
    }
    
    // ツールバーにあるdoneボタンがタップされた時の処理
    @objc private func didDoneButtonTapped(_ sender: UIBarButtonItem) {
        // キーボードを隠す
        taskTitle?.resignFirstResponder()
        taskContent?.resignFirstResponder()
        dueDateTextField?.resignFirstResponder()
    }
    
    // 期日テキストフィールドに整形したDateを設定
    @objc private func setText(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateStyle = .long
        df.locale = Locale(identifier: "ja")
        dueDateTextField?.text = df.string(from: sender.date)
        
        dueDate = sender.date
    }
}
