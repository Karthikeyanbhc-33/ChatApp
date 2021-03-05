//
//  CustomProgressView.swift
//  ChatApp
//
//  Created by Karthikeyan on 05/03/21.
//

import UIKit

open class IJProgressView {

    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()



    open class var shared: IJProgressView {
        struct Static {
            static let instance: IJProgressView = IJProgressView()
        }
        return Static.instance
    }

    open func showProgressView(_ view: UIView, isFullScreen: Bool? = false) {

        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor(hex: 0xF9F9F9, alpha: 0.5)
        progressView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        progressView.center = view.center
        progressView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 1)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.style = .large
        activityIndicator.color = UIColor.black //UIColor(hex: 0xFF7F00, alpha: 1)
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)

        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)

        if isFullScreen! {
            //let appWindow = UIApplication.shared.keyWindow
            let appWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            appWindow?.addSubview(containerView)
        } else {
            view.addSubview(containerView)
        }

        activityIndicator.startAnimating()

    }

    open func hideProgressView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
        }
    }
}

extension UIColor {

    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
