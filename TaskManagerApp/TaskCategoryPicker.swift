//
//  TaskCategoryPicker.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/01/21.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import UIKit

class TaskCategoryPicker: UIView {
    
    @IBOutlet var picker: UIPickerView?
    @IBOutlet var toolbar: UIToolbar?
    
    static private let screenHeight = UIScreen.main.bounds.height
    static private let screenWidth = UIScreen.main.bounds.width
    static private let defaultPickerHeight: CGFloat = 250
    static private let duration = 0.2
    
    private var selectItems: [String] = [String]()
    private var selectRow: Int = 0
    
    required init(frame: CGRect = CGRect(x: 0, y: screenHeight, width: screenWidth, height: defaultPickerHeight), selectItems: [String]) {
        var frame = frame
        if let safeAreaTopInsets = UIApplication.shared.keyWindow?.safeAreaInsets.top,
            safeAreaTopInsets > CGFloat(0.0) {
            
            frame = CGRect(x: 0, y: frame.origin.y, width: frame.size.width, height: (frame.size.height + 100.0))
        }
        super.init(frame: frame)
        self.selectItems = selectItems
        self.xibViewSet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.xibViewSet()
    }
    
    // PickerViewを表示する
    func showPickerView() {
        let pickerViewWidth = self.frame.size.width
        let pickerViewHeight = self.frame.size.height
        let pickerViewYPosition = TaskCategoryPicker.screenHeight - pickerViewHeight
        UIView.animate(withDuration: TaskCategoryPicker.duration, animations: {
            self.frame = CGRect.init(x: 0, y: pickerViewYPosition, width: pickerViewWidth, height: pickerViewHeight)
        }, completion: nil)
    }
    
    // PickerViewを非表示にする
    func hiddenPickerView() {
        let pickerViewWidth = self.frame.size.width
        let pickerViewHeight = self.frame.size.height
        UIView.animate(withDuration: TaskCategoryPicker.duration, animations: {
            self.frame = CGRect.init(x: 0, y: TaskCategoryPicker.screenHeight, width: pickerViewWidth, height: pickerViewHeight)
        }, completion: nil)
    }
    
    @IBAction func didDoneButtonTapped(_ sender: UIBarButtonItem) {
        hiddenPickerView()
    }
    
    private func xibViewSet() {
        /**
         loadNibNamed(_name:owner:options:) : https://developer.apple.com/documentation/foundation/bundle/1618147-loadnibnamed
         owner : File's owner of the nib
         String(describing: type(of: self))の意味：クラス名を取得する
         */
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            picker?.delegate = self
            picker?.dataSource = self
            picker?.showsSelectionIndicator = true
            
        }
    }
}

extension TaskCategoryPicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
        showPickerView()
    }
}

extension TaskCategoryPicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectItems.count
    }
}
