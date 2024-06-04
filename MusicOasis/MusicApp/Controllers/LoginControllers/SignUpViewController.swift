//
//  SignUpViewController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 19/05/23.
//

import Foundation
import UIKit
import FirebaseAuth
import NVActivityIndicatorView
import SwiftEntryKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    

    let emailTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.white
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 5
        field.placeholder = "email"
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return field
    }()
    
    let emailBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    let fullNameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.white
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 5
        field.placeholder = "full name"
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return field
    }()
    
    
    let fullNameBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    let usernameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.white
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 5
        field.placeholder = "username"
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return field
    }()
    
    let usernameBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    let passwordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.white
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 5
        field.placeholder = "password"
        field.autocapitalizationType = .none
        field.textContentType = .newPassword
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.isSecureTextEntry = true
       
        return field
    }()
    
    let passwordBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    let reEnterPasswordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.white
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 5
        field.placeholder = "re-enter password"
        field.autocapitalizationType = .none
        field.textContentType = .newPassword
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.isSecureTextEntry = true
        
        return field
    }()
    
    let reEnterPasswordBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 5
        return view
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    let loginView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an account?"
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        
        return label
    }()
    
    let loginButton: UIButton = {
       
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("login", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1), for: .normal)
        
        return button
    }()
    
    var activityIndicator: NVActivityIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        reEnterPasswordTextField.delegate = self
        
        view.addSubview(emailTextField)
        view.addSubview(emailBackgroundView)
        
//        view.addSubview(fullNameTextField)
//        view.addSubview(fullNameBackgroundView)
        
//        view.addSubview(usernameTextField)
//        view.addSubview(usernameBackgroundView)
        
        view.addSubview(passwordTextField)
        view.addSubview(passwordBackgroundView)
        
        view.addSubview(reEnterPasswordTextField)
        view.addSubview(reEnterPasswordBackgroundView)
        
        
         view.addSubview(signUpButton)
        view.addSubview(loginView)
        loginView.addSubview(loginLabel)
        loginView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            emailBackgroundView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            emailBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            emailBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            emailBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 155),
            
//            fullNameTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
//            fullNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            fullNameTextField.heightAnchor.constraint(equalToConstant: 50),
//            fullNameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
//
//            fullNameBackgroundView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
//            fullNameBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
//            fullNameBackgroundView.heightAnchor.constraint(equalToConstant: 50),
//            fullNameBackgroundView.topAnchor.constraint(equalTo: emailBackgroundView.bottomAnchor, constant: 15),
//
//            usernameTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
//            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
//            usernameTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 15),
//
//            usernameBackgroundView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
//            usernameBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
//            usernameBackgroundView.heightAnchor.constraint(equalToConstant: 50),
//            usernameBackgroundView.topAnchor.constraint(equalTo: fullNameBackgroundView.bottomAnchor, constant: 15),

            
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            
            passwordBackgroundView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            passwordBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            passwordBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            passwordBackgroundView.topAnchor.constraint(equalTo: emailBackgroundView.bottomAnchor, constant: 15),
            
            reEnterPasswordTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            reEnterPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reEnterPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            reEnterPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            
            reEnterPasswordBackgroundView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            reEnterPasswordBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            reEnterPasswordBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            reEnterPasswordBackgroundView.topAnchor.constraint(equalTo: passwordBackgroundView.bottomAnchor, constant: 15),
        
            
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: reEnterPasswordTextField.bottomAnchor, constant: 40),
            
            loginView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 80),
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            loginView.heightAnchor.constraint(equalToConstant: 60),
            
            loginLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor, constant: 20),
            loginLabel.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 5),
            loginLabel.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -5),
            
            loginButton.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 5),
            loginButton.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -5),
            loginButton.leadingAnchor.constraint(equalTo: loginLabel.trailingAnchor, constant: 5)
        
        ])
        
        emailTextField.layer.zPosition = 1
//        fullNameTextField.layer.zPosition = 1
//        usernameTextField.layer.zPosition = 1
        passwordTextField.layer.zPosition = 1
        reEnterPasswordTextField.layer.zPosition = 1
        
        emailBackgroundView.isUserInteractionEnabled = false
//        fullNameBackgroundView.isUserInteractionEnabled = false
//        usernameBackgroundView.isUserInteractionEnabled = false
        passwordBackgroundView.isUserInteractionEnabled = false
        reEnterPasswordBackgroundView.isUserInteractionEnabled = false
        
        
        signUpButton.isUserInteractionEnabled = false
        signUpButton.backgroundColor = UIColor.gray
        
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 12.5, y: self.view.frame.height/2, width: 25, height: 25), type: .lineSpinFadeLoader, color: UIColor(red: 9 / 255, green: 150 / 255, blue: 108 / 255, alpha: 1))

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textFieldsHaveText() {
            signUpButton.backgroundColor = UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1)
            signUpButton.isUserInteractionEnabled = true
        }
    }
    
    
    @objc private func signUpPressed() {
        
        print(#function)
                
        if textFieldsHaveText() {
            
            showIndicator()
            
                FirestoreUser.signUp(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] error in
                    
                    guard let strongSelf = self else {return}
                    
                    if error == nil {
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController("TabBarController")
                    } else {
                        //TODO: Present sign up error to the user.
                        
                        EKCustomPresentation(
                            animationType: EKAttributes.topFloat,
                            titleText: "Error signing up",
                            descriptionText: error?.localizedDescription,
                            gradientColor1: UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1),
                            gradientColor2: UIColor(red: 9 / 255, green: 150 / 255, blue: 108 / 255, alpha: 1),
                            startPoint: CGPoint(x: 0, y: 0.5),
                            endPoint: CGPoint(x: 2, y: 0.5),
                            titleFont: UIFont.systemFont(ofSize: 20, weight: .medium),
                            descriptionFont: UIFont.systemFont(ofSize: 16, weight: .medium)
                        )
                        
                    }
                    
                    strongSelf.hideIndicator()

                }
                
        }
        
    }
    
    @objc private func loginPressed() {
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController("LoginViewController")
    }
    
    
    func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "" && reEnterPasswordTextField.text != "")
    }
    
    
    func showIndicator() {
        if activityIndicator != nil {
            view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    func hideIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator?.stopAnimating()
        }
    }
    
}
