//
//  MessageViewModel.swift
//  ChatApp
//
//  Created by Karthikeyan on 05/03/21.
//

import Foundation
import Foundation
import UIKit


struct MessageModel {
    let message: String
    let sender: String?
    let time: String?
    let isIncoming: Bool
}

class MessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let messageBgView = UIView()
    
    
    var isIncoming: Bool = false {
        didSet {
            messageBgView.backgroundColor = isIncoming ? UIColor.white : #colorLiteral(red: 0.8823529412, green: 0.968627451, blue: 0.7921568627, alpha: 1)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(messageBgView)
        addSubview(messageLabel)
        messageBgView.translatesAutoresizingMaskIntoConstraints = false
        messageBgView.layer.cornerRadius = 7
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // set constraints for the message and the background view
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            messageBgView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            messageBgView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            messageBgView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            messageBgView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(constraints)

        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func millisToCurrentDate(millis: String) -> String {
            let date = Date(timeIntervalSince1970: (Double(millis)! / 1000.0))
               let dateFormatter = DateFormatter()
       
                // dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        dateFormatter.dateFormat = "MMM d, h:mm a"
                 //  dateFormatter.dateFormat = "d MMM yyyy h:mm a"
               dateFormatter.timeZone = .current
              let currentDate = dateFormatter.string(from: date)
             return currentDate
    }
    
    func configure(with model: MessageModel) {
        isIncoming = model.isIncoming
        if isIncoming {
            guard let sender = model.sender else {return}
            let nameAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.orange,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                ] as [NSAttributedString.Key : Any]
            let timeAttribute = [
                NSAttributedString.Key.foregroundColor : UIColor.lightGray,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)
                ] as [NSAttributedString.Key : Any]
            // sender name at top, message at the next line
            let senderName = NSMutableAttributedString(string: sender + "\n", attributes: nameAttributes)
            let message = NSMutableAttributedString(string: model.message + "\n\n")
            var actualTime = ""
            if model.time != nil {
                actualTime = millisToCurrentDate(millis: model.time!)
            }
            let timeInfo = NSMutableAttributedString(string: "\t\t\t\t\t\t\t\t\t\(actualTime)", attributes: timeAttribute)
            
           // let time = NSMutableAttributedString(string: "\n\n\t\t\t\t 10 am")
            senderName.append(message)
            senderName.append(timeInfo)
            messageLabel.attributedText = senderName
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = false
        }
        else {
            let timeAttribute = [
                NSAttributedString.Key.foregroundColor : UIColor.lightGray,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                ] as [NSAttributedString.Key : Any]
            let message = NSMutableAttributedString(string: model.message + "\n\n")
            var actualTime = ""
            if model.time != nil {
                actualTime = millisToCurrentDate(millis: model.time!)
            }
            let msgAndTime = NSMutableAttributedString(string: "\t\(actualTime)", attributes: timeAttribute)
            message.append(msgAndTime)
            
            messageLabel.attributedText = message
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = false
        }
    }
}




