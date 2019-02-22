//
//  TaskForm.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/01/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

protocol TaskFormControllerDelegate: AnyObject {
    func taskFormControllerDidTapCancel(_ taskFormController: TaskFormController)
}

class TaskFormController: UIViewController {
    
    @IBOutlet var dueDateTextField: UITextField?
    @IBOutlet var taskTitle: UITextField?
    @IBOutlet var taskContent: UITextField?
    @IBOutlet var registerButton: UIButton?
    @IBOutlet var cancelButton: UIButton?
    @IBOutlet var checkButton: UIButton?
    @IBOutlet var taskCategory: UITextField?
    @IBOutlet var taskCategoryAddButton: UIButton?
    
    weak var delegate: TaskFormControllerDelegate?
    
    let buttonTitle: String
    let task: Task
    let taskCategories = ["勉強", "課題", "その他"]
    
    var dueDate: Date = Date()
    var taskCompleted: Bool = false
    
    init(task: Task, buttonTitle: String) {
        self.task = task
        self.buttonTitle = buttonTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkButton?.setImage(UIImage(named: "blank_checkbox"), for: .normal)
        
        initializeFields()
        initializeButton()
    }
    
    // 登録，編集ボタンがタップされた時の処理
    @IBAction func didSubmitButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "00adb5")

        if let task = TaskRepository.sharedInstance.findTask(primaryKey: task.id){
            TaskRepository.sharedInstance.updateTask(task: task, title: taskTitle?.text, category: taskCategory?.text,
                                                     content: taskContent?.text, dueDate: dueDate, checked: taskCompleted)
        } else {
            TaskRepository.sharedInstance.createTask(title: taskTitle?.text, category: taskCategory?.text,
                                                     content: taskContent?.text, dueDate: dueDate, checked: taskCompleted)
        }
        
        (presentingViewController as? ViewController)?.tableView?.reloadData()
        delegate?.taskFormControllerDidTapCancel(self)
    }
    
    // カテゴリー追加ボタンが押された時の処理
    @IBAction func categoryAddButtonDidTapped(_ sender: UIButton) {
        let alertView = createTextInputAlert()
        self.present(alertView, animated: true, completion: nil)
    }
    
    // ボタンが押された時の処理
    @IBAction func checkButtonDidTapped(_ sender: UIButton) {
        checkButton?.isSelected = false
        changeCheckBoxState()
    }
    
    @IBAction func cancelButtonDidTapped(_ sender: UIButton) {
        delegate?.taskFormControllerDidTapCancel(self)
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
    
    // タスクのカテゴリー用PickerViewを作成するメソッド
    private func createTaskCategoryPickerView() -> UIPickerView {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
        picker.delegate = self
        picker.dataSource = self
        return picker
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
        
        taskTitle?.text = task.title
        taskContent?.text = task.content
        taskCategory?.text = task.category
        dueDateTextField?.text = df.string(from: task.dueDate)
        
        // チェックボックスはフラグで管理しているためフラグに入れる
        taskCompleted = task.checked
        if taskCompleted {
            checkButton?.setImage(UIImage(named: "checked_checkbox"), for: .normal)
        } else {
            checkButton?.setImage(UIImage(named: "blank_checkbox"), for: .normal)
        }
        
        taskTitle?.inputAccessoryView = createToolBar()
        taskContent?.inputAccessoryView = createToolBar()
        taskCategory?.inputAccessoryView = createToolBar()
        taskCategory?.inputView = createTaskCategoryPickerView()
        
        // 期日のテキストフィールドの入力方法のビューについて設定
        dueDateTextField?.inputView = createDatePickerView()
        
        // 出てくる期日入力用ビューのツールバー部分を設定
        dueDateTextField?.inputAccessoryView = createToolBar()
    }
    
    // Buttonの設定
    private func initializeButton() {
        registerButton?.setTitle(buttonTitle, for: .normal)
    }
    
    // チェックボックスの状態を変える処理
    private func changeCheckBoxState() {
        if taskCompleted {
            checkButton?.setImage(UIImage(named: "blank_checkbox"), for: .normal)
            taskCompleted = false
        } else {
            checkButton?.setImage(UIImage(named: "checked_checkbox"), for: .normal)
            taskCompleted = true
        }
    }
    
    // テキスト入力可能なアラートを作成
    private func createTextInputAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "カテゴリー追加", message: "追加したいカテゴリー名を入力してください。", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: ({ (textField) in
            textField.placeholder = "カテゴリー名"
            textField.keyboardAppearance = .dark
        }))
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        let registerAction = UIAlertAction(title: "登録", style: .default, handler: { (action) in
            if let categoryName = alertController.textFields?.first?.text {
                CategoryRepository.sharedInstance.createCategory(name: categoryName)
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(registerAction)
        
        return alertController
    }
    
    // ツールバーにあるdoneボタンがタップされた時の処理
    @objc private func didDoneButtonTapped(_ sender: UIBarButtonItem) {
        // キーボードを隠す
        taskTitle?.resignFirstResponder()
        taskContent?.resignFirstResponder()
        taskCategory?.resignFirstResponder()
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


extension TaskFormController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return taskCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        taskCategory?.text = taskCategories[row]
    }
}

extension TaskFormController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taskCategories.count
    }
}
