//
//  TaskDetailViewController.swift
//  test
//
//  Created by Admin on 09/06/24.
//

import UIKit
import SnapKit
import Firebase

class TaskDetailViewController: UIViewController {


    var task: Task!
    var comments: [Comment] = []
    var textComment: Comment!
    var ref: DatabaseReference!

    // UI элементы
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var statusLabel: UILabel!
    var executorLabel: UILabel!
    var deadlineLabel: UILabel!
    
    var commentsLabel =  UILabel()
    var commentsTextView = UITextView()
    var addCommentTextField = UITextField()
    
    
    
    let addParametrButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить параметр", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(addParametrButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    let addCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить комментарий", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(addCommentButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Информация о задаче"
        view.backgroundColor = .white
        
        ref = Database.database().reference().child("tasks").child(task.id).child("comments")

        setupViews()
        setupConstraints()
        displayTaskDetails()
        fetchComments()

    }






    func setupViews() {


        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 2
        view.addSubview(descriptionLabel)

        statusLabel = UILabel()
        view.addSubview(statusLabel)

        executorLabel = UILabel()
        view.addSubview(executorLabel)

        deadlineLabel = UILabel()
        view.addSubview(deadlineLabel)

        view.addSubview(addParametrButton)
        view.addSubview(addCommentButton)
        
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        view.addSubview(nameLabel)
        
        
        

        view.addSubview(commentsLabel)
        commentsLabel.text = "Комментарии:"

        
        view.addSubview(commentsTextView)
        commentsTextView.isEditable = false
        commentsTextView.backgroundColor = .red
        commentsTextView.font = .systemFont(ofSize: 18, weight: .regular)
        
        
        view.addSubview(addCommentTextField)
        addCommentTextField.placeholder = "Введите комментарий"
        addCommentTextField.borderStyle = .roundedRect
        addCommentTextField.backgroundColor = .systemGray6

        }
    



        func setupConstraints() {
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            }
            


            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.left.right.equalTo(nameLabel)
            }

            statusLabel.snp.makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
                make.left.right.equalTo(descriptionLabel)
            }

            executorLabel.snp.makeConstraints { make in
                make.top.equalTo(statusLabel.snp.bottom).offset(10)
                make.left.right.equalTo(statusLabel)
            }

            deadlineLabel.snp.makeConstraints { make in
                make.top.equalTo(executorLabel.snp.bottom).offset(10)
                make.left.right.equalTo(executorLabel)
            }
            
            
            commentsLabel.snp.makeConstraints { make in
                make.top.equalTo(deadlineLabel.snp.bottom).offset(10)
                make.left.equalTo(executorLabel)
            }
            
            
            commentsTextView.snp.makeConstraints { make in
                make.top.equalTo(commentsLabel.snp.bottom).offset(10)
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(120)
            }
            
            addCommentTextField.snp.makeConstraints { make in
                make.top.equalTo(commentsTextView.snp.bottom).offset(10)
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(40)
            }
            
            
            addParametrButton.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(400)
                make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.height.equalTo(40)
                make.width.equalTo(200)
            }
            
            addCommentButton.snp.makeConstraints { make in
                make.top.equalTo(addParametrButton.snp.bottom).offset(20)
                make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.height.equalTo(40)
                make.width.equalTo(200)
            }
            
        }

        func displayTaskDetails() {
            nameLabel.text = task.name
            descriptionLabel.text = "Описание: \(task.description)"
            statusLabel.text = "Статус задачи: \(task.status)"
            executorLabel.text = "Исполнитель: \(task.executor)"
            deadlineLabel.text = "Срок выполнения: \(task.deadline)"
        }
    
    
    
    
    

    @objc func addParametrButtonTapped() {

        let editTaskVC = EditTaskViewController()
        editTaskVC.task = task
        //navigationController?.pushViewController(editTaskVC, animated: true)
        present(editTaskVC, animated: true)
    }
    
    
    
    func fetchComments() {
//        ref.observe(DataEventType.value, with: { (snapshot) in
//            self.comments.removeAll()
//
//            for child in snapshot.children {
//                if let commentSnapshot = child as? DataSnapshot,
//                   let commentText = commentSnapshot.value as? String {
//                    self.comments.append(commentText)
//                }
//            }
//
//            self.commentsTextView.text = self.comments.joined(separator: "\n")
//        })
        
        ref.observe(DataEventType.value, with: { snapshot in
            self.comments.removeAll()

            for child in snapshot.children {
                if let commentSnapshot = child as? DataSnapshot,
                   let comment = Comment(snapshot: commentSnapshot) {
                    self.comments.append(comment)
                }
            }

            self.commentsTextView.text = self.comments.map { "\($0.author): \($0.text): \($0.timestamp)" }.joined(separator: "\n")
        })
    }
    
    
    @objc func addCommentButtonTapped() {


//        guard let commentText = addCommentTextField.text, !commentText.isEmpty else { return }
//
//        let commentRef = ref.childByAutoId()
//        commentRef.setValue(commentText)
//        addCommentTextField.text = ""
        
        guard let commentText = addCommentTextField.text, !commentText.isEmpty else { return }
        
        let commentId = ref.childByAutoId().key ?? UUID().uuidString
        //let author = "Автор" // Здесь можно использовать текущего пользователя
        let author = getCurrentUserName()
        let timestamp = formatTimestamp(Date())
        
        let newComment = Comment(id: commentId, text: commentText, author: author, timestamp: timestamp)
        
        ref.child(commentId).setValue(newComment.toDictionary())
        addCommentTextField.text = ""
        
    }
    
    
    func getCurrentUserName() -> String {
        // Получение имени пользователя из Firebase Auth
        return Auth.auth().currentUser?.displayName ?? "Неизвестный пользователь"
    }

    func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: date)
    }

}



//extension TaskDetailViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return comments.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
//        let comment = comments[indexPath.row]
//        cell.textLabel?.text = comment.text
//
//        return cell
//    }
//
//
//}






/*
 
 import UIKit
 import SnapKit
 import Firebase

 class TaskDetailViewController: UIViewController {


     var task: Task!
     var comments: [Comment] = []
     var textComment: Comment!
     var ref: DatabaseReference!

     // UI элементы
     var nameLabel: UILabel!
     var descriptionLabel: UILabel!
     var statusLabel: UILabel!
     var executorLabel: UILabel!
     var deadlineLabel: UILabel!
     //var commentsLabel: UILabel!
     //var commentsTextView: UITextView!
     //var commentsTableView: UITableView!
     //var addCommentTextField: UITextField!
     
     
     
     let addCommentButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("Добавить комментарий", for: .normal)
         button.backgroundColor = .systemBlue
         button.setTitleColor(.white, for: .normal)
         button.addTarget(nil, action: #selector(addCommentButtonTapped), for: .touchUpInside)
         button.layer.cornerRadius = 8
         return button
     }()

     override func viewDidLoad() {
         super.viewDidLoad()

         title = "Информация о задаче"
         view.backgroundColor = .white

         setupViews()
         setupConstraints()
         displayTaskDetails()


         ref = Database.database().reference().child("comments").child(task.id)
     }






     func setupViews() {


         descriptionLabel = UILabel()
         descriptionLabel.numberOfLines = 0
         view.addSubview(descriptionLabel)

         statusLabel = UILabel()
         view.addSubview(statusLabel)

         executorLabel = UILabel()
         view.addSubview(executorLabel)

         deadlineLabel = UILabel()
         view.addSubview(deadlineLabel)

 //        commentsLabel = UILabel()
 //        commentsLabel.text = "Комментарии:"
 //        view.addSubview(commentsLabel)

 //        commentsTextView = UITextView()
 //        commentsTextView.isEditable = true
 //        view.addSubview(commentsTextView)
 //
         view.addSubview(addCommentButton)
         
         
         
         nameLabel = UILabel()
         nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
         nameLabel.numberOfLines = 0
         view.addSubview(nameLabel)

 //        commentsTableView = UITableView()
 //        commentsTableView.delegate = self
 //        commentsTableView.dataSource = self
 //        commentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
 //        view.addSubview(commentsTableView)




 //        addCommentTextField = UITextField()
 //        addCommentTextField.placeholder = "Введите комментарий"
 //        addCommentTextField.borderStyle = .roundedRect
 //        addCommentTextField.backgroundColor = .systemGray6
 //        view.addSubview(addCommentTextField)





         }
     
         @objc func addCommentButtonTapped() {
 //            guard let commentText = addCommentTextField.text else { return }
 //
 //            let comment = ["text": commentText]
 //            ref?.childByAutoId().setValue(comment)
 //            addCommentTextField.text = ""
         }


         func setupConstraints() {
             nameLabel.snp.makeConstraints { make in
                 make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
                 make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
                 make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
             }
             
 //            commentsTableView.snp.makeConstraints { make in
 //                make.top.equalTo(commentsLabel.snp.bottom).offset(230)
 //                make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
 //                make.height.equalTo(350) // Например, для определения высоты таблицы
 //            }
 //

             descriptionLabel.snp.makeConstraints { make in
                 make.top.equalTo(nameLabel.snp.bottom).offset(10)
                 make.left.right.equalTo(nameLabel)
             }

             statusLabel.snp.makeConstraints { make in
                 make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
                 make.left.right.equalTo(descriptionLabel)
             }

             executorLabel.snp.makeConstraints { make in
                 make.top.equalTo(statusLabel.snp.bottom).offset(10)
                 make.left.right.equalTo(statusLabel)
             }

             deadlineLabel.snp.makeConstraints { make in
                 make.top.equalTo(executorLabel.snp.bottom).offset(10)
                 make.left.right.equalTo(executorLabel)
             }

 //            commentsLabel.snp.makeConstraints { make in
 //                make.top.equalTo(deadlineLabel.snp.bottom).offset(20)
 //                make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
 //            }
 //
 //            addCommentTextField.snp.makeConstraints { make in
 //                make.top.equalTo(commentsLabel.snp.bottom).offset(100)
 //                //make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
 //                make.width.equalTo(300)
 //                make.height.equalTo(50)
 //                make.left.equalTo(view.safeAreaLayoutGuide).inset(20)
 //            }

 //            commentsTextView.snp.makeConstraints { make in
 //                make.top.equalTo(commentsLabel.snp.bottom).offset(10)
 //                make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
 //                make.height.equalTo(120)
 //            }

 //            addCommentButton.snp.makeConstraints { make in
 //                make.top.equalTo(commentsTextView.snp.bottom).offset(10)
 //                make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
 //                make.height.equalTo(50)
 //                make.width.equalTo(200)
 //            }
             
             addCommentButton.snp.makeConstraints { make in
                 make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
                 make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
                 make.height.equalTo(40)
                 make.width.equalTo(200)
             }
             
             
         }

         func displayTaskDetails() {
             nameLabel.text = task.name
             descriptionLabel.text = "Описание: \(task.description)"
             statusLabel.text = "Статус задачи: \(task.status)"
             executorLabel.text = "Исполнитель: \(task.executor)"
             deadlineLabel.text = "Срок выполнения: \(task.deadline)"
             //commentsTextView.text = "Тут будут комментарии  "
         }


     func fetchComments() {
         ref?.observe(DataEventType.value, with: { (snapshot) in
                 if snapshot.childrenCount > 0 {
                     self.comments.removeAll()

                     for commentSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                         if let commentObject = commentSnapshot.value as? [String: AnyObject] {
                             let commentText = commentObject["text"]
                             let comment = Comment(id: commentSnapshot.key,
                                                   text: commentText as? String ?? "",
                                                   taskId: self.task.id)
                             self.comments.append(comment)
                         }
                     }

                     //self.commentsTableView.reloadData()
                 }
             })
         }

     
     

 }


 extension TaskDetailViewController: UITableViewDataSource, UITableViewDelegate {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return comments.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
         let comment = comments[indexPath.row]
         cell.textLabel?.text = comment.text

         return cell
     }

 }
 
 */
