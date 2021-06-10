//
//  AlertVC.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 10/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

 
import UIKit

class AlertVC: UIViewController {
    
      let containerView   = UIView()
      let titleLabel      = CustomTitleLabel(textAlignment: .center, fontSize: 20)
      let messageLabel    = customBodyLabel(textAlignment: .center)
      let actionButton    = MyCustomButton(backgroundColor: .systemPink, title: "Ok")
      
      var alertTitle: String?
      var message: String?
      var buttonTitle: String?
      
      let padding: CGFloat = 20
      
      
      init(title: String, message: String, buttonTitle: String) {
          super.init(nibName: nil, bundle: nil)
          self.alertTitle     = title
          self.message        = message
          self.buttonTitle    = buttonTitle
      }
      
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      
      override func viewDidLoad() {
          super.viewDidLoad()
          view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
          configureContainerView()
          configureTitleLabel()
          configureActionButton()
          configureMessageLabel()
      }
      
      
      func configureContainerView() {
          view.addSubview(containerView)
          containerView.backgroundColor       = .systemBackground
          containerView.layer.cornerRadius    = 16
          containerView.layer.borderWidth     = 2
          containerView.layer.borderColor     = UIColor.white.cgColor
          containerView.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
              containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
              containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              containerView.widthAnchor.constraint(equalToConstant: 280),
              containerView.heightAnchor.constraint(equalToConstant: 220)
          ])
      }
      
      
      func configureTitleLabel() {
          containerView.addSubview(titleLabel)
          titleLabel.text = alertTitle ?? "Something went wrong"
          
          NSLayoutConstraint.activate([
              titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
              titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
              titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
              titleLabel.heightAnchor.constraint(equalToConstant: 28)
          ])
      }
      
      
      func configureActionButton() {
          containerView.addSubview(actionButton)
          actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
          actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
          
          NSLayoutConstraint.activate([
              actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
              actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
              actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
              actionButton.heightAnchor.constraint(equalToConstant: 44)
          ])
      }
      
      
      func configureMessageLabel() {
          containerView.addSubview(messageLabel)
          messageLabel.text           = message ?? "Unable to complete request"
          messageLabel.numberOfLines  = 4
          
          NSLayoutConstraint.activate([
              messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
              messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
              messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
              messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
          ])
      }
      
      
      @objc func dismissVC() {
          dismiss(animated: true)
      }
}


class CustomTitleLabel: UILabel {
    override init(frame: CGRect) {
           super.init(frame: frame)
           configure()
       }
       
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       
       init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
           super.init(frame: .zero)
           self.textAlignment = textAlignment
           self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
           configure()
       }
       
       
       private func configure() {
           textColor                   = .label
           adjustsFontSizeToFitWidth   = true
           minimumScaleFactor          = 0.9
           lineBreakMode               = .byTruncatingTail
           translatesAutoresizingMaskIntoConstraints = false
       }
}

class customBodyLabel: UILabel {

  
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    
    private func configure() {
        textColor                   = .secondaryLabel
        font                        = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.75
        lineBreakMode               = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}

class MyCustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        configure()
    }
    
    init(backgroundColor:UIColor ,title:String) {
        super.init(frame:.zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configure(){
        layer.cornerRadius    =  10
        titleLabel?.textColor =  .white
        titleLabel?.font      =  UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints=false
        
    }
    func set(backgroundColor:UIColor ,title:String) {
    self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)}
}

