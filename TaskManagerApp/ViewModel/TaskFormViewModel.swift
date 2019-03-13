//
//  TaskFormViewModel.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/03/13.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TaskParameters {
    var id: Int = -1
    var title: String = ""
    var category: String = ""
    var content: String = ""
    var dueDate: Date = Date()
    var checked: Bool = false
    
    init() {}
    
    init(id: Int?, title: String, category: String,
        content: String, dueDate: Date, checked: Bool) {
        self.id = id ?? -1
        self.title = title
        self.category = category
        self.content = content
        self.dueDate = dueDate
        self.checked = checked
    }
}

class TaskFormViewModel {
    
    private let disposeBag = DisposeBag()
    
    let createOrUpdateTask: AnyObserver<TaskParameters>
    
    init() {
        let createOrUpdateTaskSubject = PublishSubject<TaskParameters>()
        
        createOrUpdateTask = createOrUpdateTaskSubject.asObserver()
        
        createOrUpdateTaskSubject.asObservable()
            .subscribe(onNext: { param in
                if let task = TaskRepository.sharedInstance.findTask(primaryKey: param.id){
                    TaskRepository.sharedInstance.updateTask(task: task, title: param.title, category: param.content,
                                                             content: param.content, dueDate: param.dueDate, checked: param.checked)
                } else {
                    TaskRepository.sharedInstance.createTask(title: param.title, category: param.category,
                                                             content: param.content, dueDate: param.dueDate, checked: param.checked)
                }
            }).disposed(by: disposeBag)
    }
}
