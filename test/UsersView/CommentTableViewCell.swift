//
//  CommentTableViewCell.swift
//  test
//
//  Created by Admin on 11/06/24.
//

import UIKit
import SnapKit

class CommentTableViewCell: UITableViewCell {


        let emailLabel = UILabel()
        let nameLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupViews()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupViews() {
            contentView.addSubview(emailLabel)
            contentView.addSubview(nameLabel)
            
            nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            emailLabel.font =  UIFont.systemFont(ofSize: 14)
            nameLabel.numberOfLines = 2
        }
        
        func setupConstraints() {

            
            nameLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.right.equalToSuperview().inset(10)
            }
            
            emailLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.left.right.equalToSuperview().inset(10)
            }
        }
    
    
    
    // Обновление интерфейса ячейки с данными задачи
    private func updateUI(email: String?, name: String?) {
        self.emailLabel.text = email
        self.nameLabel.text = name

    }
    
    private(set) var task: ListUser! // Свойство для хранения информации о задаче
        
    func configure(with comment: ListUser) {
        self.task = comment
        
        updateUI(email: comment.email, name: comment.name)
        
        //emailLabel.text = comment.email
        //nameLabel.text = comment.name
    }
    

}
