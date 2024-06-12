//
//  Executor.swift
//  test
//
//  Created by Admin on 12/06/24.
//

import UIKit


protocol CustomPickerViewDelegate: AnyObject {
    func pickerView(_ pickerView: CustomPickerView, didSelectOption option: String)
}

class CustomPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    
    let pickerView = UIPickerView()
    let data = ["Option 1", "Option 2", "Option 3", "Option 4"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPickerView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPickerView()
    }

    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)
        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: self.topAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        //print("Selected: \(data[row])") // You can delegate this to ViewController
        //return data[row]
        let selectedOption = data[row]
                // Вызов метода делегата
        //delegate?.pickerView(self, didSelectOption: selectedOption)
    
    }
}
