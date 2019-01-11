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
    
    var realm: Realm?

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            realm = try Realm()
        } catch {
            print("Failed : Realm initialize")
        }
        dueDateTextField?.inputView = createDatePickerView()
        dueDateTextField?.inputAccessoryView = createToolBarForDatePicker()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didRegisterButtonTapped(_ sender: UIButton) {
        let numberOfTasks: Int? = realm?.objects(Task.self).count
        let task = Task()
        task.id = (numberOfTasks ?? 0) + 1
        task.title = taskTitle?.text ?? ""
        task.content = taskContent?.text ?? ""
        
        do {
            try realm?.write {
                realm?.add(task)
            }
        } catch {
            print("RegisterViewController#didRegisterButtonTapped")
            print("Failed : Realm write process")
        }
        
        
    }
    
    private func createDatePickerView() -> UIDatePicker {
        let dp: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
        dp.locale = Locale.current
        dp.datePickerMode = .date
        dp.minimumDate = Date()
        dp.addTarget(self, action: #selector(setText), for: .valueChanged)
        return dp
    }
    
    private func createToolBarForDatePicker() -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDoneButtonTapped))
        toolbar.setItems([doneButtonItem], animated: true)
        
        return toolbar
    }
    
    @objc private func didDoneButtonTapped() {
        dueDateTextField?.resignFirstResponder()
    }
    
    @objc private func setText(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateStyle = .long
        df.locale = Locale(identifier: "ja")
        dueDateTextField?.text = df.string(from: sender.date)
    }
}
