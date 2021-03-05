//
//  ChatVC.swift
//  ChatApp
//
//  Created by Karthikeyan on 05/03/21.
//
import UIKit
import Firebase

class ChatsViewController: UIViewController {
    
    //chatcell identifier
    private let cellId = "chatCell"
    
    private var messages = [MessageModel]()
    let messageDB = Database.database().reference().child("Messages")
    
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messageDB.removeAllObservers()
    }
    
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        getMessages()
        hideKeyboardOnTap()
    }
    
    
    func getMessages() {
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            guard let message = snapshotValue["message"], let sender = snapshotValue["sender"], let time = snapshotValue["time"] else {return}
            let isIncoming = (sender == Auth.auth().currentUser?.email ? false : true)
            let chatMessage = MessageModel.init(message: message, sender: sender, time: time, isIncoming: isIncoming)
            self.addNewRow(with: chatMessage)
        }
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            print("user signed out")
            navigationController?.popViewController(animated: true)
        }
        catch {
            print("Error signing out")
        }
    }
    
    
    func addNewRow(with chatMessage: MessageModel) {
        self.tableView.beginUpdates()
        self.messages.append(chatMessage)
        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .top)
        self.tableView.endUpdates()
    }
    
    
    
    //MARK: Buttons
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        // return if message does not exist
        guard let message = messageTextField.text else {return}
        if message == "" {
            return
        }
    
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        let currentTimeStamp = "\(Date().toMillis() ?? 0)"
            
        print(currentTimeStamp)
        let messageDict = ["sender": Auth.auth().currentUser?.email, "message" : message, "time" : currentTimeStamp]
        
        messageDB.childByAutoId().setValue(messageDict) { (error, reference) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            else {
                print("Message sent!")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text?.removeAll()
            }
        }
    }
    
    
}

// MARK: - TableView Delegates
extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

//MARK: - TextField Delegates
extension ChatsViewController: UITextFieldDelegate {
    
    //handle when keyboard is shown and hidden
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.textFieldViewHeight.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.textFieldViewHeight.constant = 50
            self.view.layoutIfNeeded()
        }

    }
}

extension ChatsViewController {
    
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let navController = self.navigationController {
            navController.view.endEditing(true)
        }
    }
}



extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
