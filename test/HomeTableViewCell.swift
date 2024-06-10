//
//  HomeTableViewCell.swift
//  test
//
//  Created by Admin on 09/06/24.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {

 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var reuseIdentifier: String? {
        return "TaskCell"
    }
    
    
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    
    lazy var status: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var id: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var executor: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    lazy var deadline: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    lazy var director: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    
    lazy var views: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    lazy var descriptionText: UILabel = {
        let label = UILabel()
        return label
    }()

    
    
    private func setupViews() {
        contentView.addSubview(views)
        views.translatesAutoresizingMaskIntoConstraints = false
        
        views.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        views.addSubview(status)
        status.translatesAutoresizingMaskIntoConstraints = false
        
        
        views.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
               
               
        name.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            //make.height.equalTo(50)
        }
               
        status.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(10)
            make.leading.equalTo(10)
            //make.width.equalTo(250)
        }
        
        
    }



    
    private func updateUI(id: String?, name: String?, description: String?, status: String?, executor: String?, deadline: String?, director: String) {

        self.id.text = id
        self.name.text = name
        self.descriptionText.text = description
        self.status.text = "Статус: \(status ?? "nil")"
        self.executor.text = executor
        self.deadline.text = deadline
        self.director.text = director
            
        
    }
        
    
    private(set) var task: Task!
    
    
    func setCellWithValuesOf(_ info: Task) {
        self.task = info
 
        updateUI(id: info.id, name: info.name, description: info.description, status: info.status, executor: info.executor, deadline: info.deadline, director: info.director)

    }
    
    
}
