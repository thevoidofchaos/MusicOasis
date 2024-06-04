//
//  LoginViewController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 19/05/23.
//

import Foundation
import UIKit
import FirebaseAuth
import NVActivityIndicatorView
import SwiftEntryKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
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
    
    
    let passwordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.white
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 5
        field.isSecureTextEntry = true
        field.placeholder = "password"
        field.autocapitalizationType = .none
        field.textContentType = .password
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return field
    }()
    
    let passwordBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 5
        return view
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("forgot password", for: .normal)
        button.setTitleColor(UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1), for: .normal)

        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    let signUpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account?"
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        
        return label
    }()
    
    let signUpButton: UIButton = {
       
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1), for: .normal)
        
        return button
    }()
    
    let resendEmailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("resend email", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1), for: .normal)
        
        return button
    }()
    
    var activityIndicator: NVActivityIndicatorView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        //MARK: - CONSTRAINTS
        
        view.addSubview(emailTextField)
        view.addSubview(emailBackgroundView)
        
        view.addSubview(passwordTextField)
        view.addSubview(passwordBackgroundView)
        
        view.addSubview(forgotPasswordButton)
        
        view.addSubview(loginButton)
        
        view.addSubview(signUpView)
        
        signUpView.addSubview(signUpLabel)
        signUpView.addSubview(signUpButton)
        
        view.addSubview(resendEmailButton)
        
        
        NSLayoutConstraint.activate([
            
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            emailBackgroundView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            emailBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            emailBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            emailBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 155),
            
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            
            passwordBackgroundView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            passwordBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            passwordBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            passwordBackgroundView.topAnchor.constraint(equalTo: emailBackgroundView.bottomAnchor, constant: 15),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordBackgroundView.bottomAnchor, constant: 10),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -2),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 60),
            
            signUpView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 80),
            signUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signUpView.heightAnchor.constraint(equalToConstant: 60),
            
            signUpLabel.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 20),
            signUpLabel.topAnchor.constraint(equalTo: signUpView.topAnchor, constant: 5),
            signUpLabel.bottomAnchor.constraint(equalTo: signUpView.bottomAnchor, constant: -5),
            
            signUpButton.topAnchor.constraint(equalTo: signUpView.topAnchor, constant: 5),
            signUpButton.bottomAnchor.constraint(equalTo: signUpView.bottomAnchor, constant: -5),
            signUpButton.leadingAnchor.constraint(equalTo: signUpLabel.trailingAnchor, constant: 5),
            
            resendEmailButton.topAnchor.constraint(equalTo: signUpView.bottomAnchor, constant: 5),
            resendEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resendEmailButton.heightAnchor.constraint(equalToConstant: 20)

        
        ])
        
        //END
        
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
        passwordTextField.layer.zPosition = 1
        emailTextField.layer.zPosition = 1
        
        passwordBackgroundView.isUserInteractionEnabled = false
        emailBackgroundView.isUserInteractionEnabled = false
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordPressed), for: .touchUpInside)
        
        loginButton.isUserInteractionEnabled = false
        loginButton.backgroundColor = UIColor.gray
        
        resendEmailButton.isHidden = true
        
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        
        resendEmailButton.addTarget(self, action: #selector(resendEmailPressed), for: .touchUpInside)
        
        
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
            loginButton.backgroundColor = UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1)
            loginButton.isUserInteractionEnabled = true
        }
    }
    
    @objc private func resendEmailPressed() {
        
        print(#function)
    }
    
    @objc private func forgotPasswordPressed() {
        if let email = emailTextField.text, emailTextField.text != "" {
            FirestoreUser.forgotPassword(email: email) { error in
                
                if error != nil {
                    
                    EKCustomPresentation(
                        animationType: EKAttributes.topFloat,
                        titleText: "Error",
                        descriptionText: error?.localizedDescription,
                        gradientColor1: UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1),
                        gradientColor2: UIColor(red: 9 / 255, green: 150 / 255, blue: 108 / 255, alpha: 1),
                        startPoint: CGPoint(x: 0, y: 0.5),
                        endPoint: CGPoint(x: 2, y: 0.5),
                        titleFont: UIFont.systemFont(ofSize: 20, weight: .medium),
                        descriptionFont: UIFont.systemFont(ofSize: 16, weight: .medium)
                    )
                }
                
                else {
                    
                    EKCustomPresentation(
                        animationType: EKAttributes.topFloat,
                        titleText: "Password reset",
                        descriptionText: "An password verification email has been sent to your registered email with a link to reset your password.",
                        gradientColor1: UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1),
                        gradientColor2: UIColor(red: 9 / 255, green: 150 / 255, blue: 108 / 255, alpha: 1),
                        startPoint: CGPoint(x: 0, y: 0.5),
                        endPoint: CGPoint(x: 2, y: 0.5),
                        titleFont: UIFont.systemFont(ofSize: 20, weight: .medium),
                        descriptionFont: UIFont.systemFont(ofSize: 16, weight: .medium)
                    )
                    
                }
                
            }
        }
    }
    
    
    @objc private func loginPressed() {
        
        print(#function)
        
        if textFieldsHaveText() {
            
            showIndicator()
            
            AuthenticationManager.shared.login(with: emailTextField.text!, password: passwordTextField.text!) { [weak self] (error, emailVerified, userUid) in
                
                guard let strongSelf = self else {return}
                
                if error != nil {
                    //TODO: Present login error to the user.
        
                    EKCustomPresentation(
                        animationType: EKAttributes.topFloat,
                        titleText: "Error logging in",
                        descriptionText: error?.localizedDescription,
                        gradientColor1: UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1),
                        gradientColor2: UIColor(red: 9 / 255, green: 150 / 255, blue: 108 / 255, alpha: 1),
                        startPoint: CGPoint(x: 0, y: 0.5),
                        endPoint: CGPoint(x: 2, y: 0.5),
                        titleFont: UIFont.systemFont(ofSize: 20, weight: .medium),
                        descriptionFont: UIFont.systemFont(ofSize: 16, weight: .medium)
                    )
                    
                    
                } else {
                    
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController("TabBarController")
                    
                    
                    //TODO: Implement later when the app's almost ready.
//                    if emailVerified {
//
//                        DatabaseManager.shared.updateUser(userId: userUid!, key: "isEmailVerified", value: true)
//
//                    } else {
//                        //TODO: Ask the user to verify email.
//
//                        EKCustomPresentation(
//                            animationType: EKAttributes.topFloat,
//                            titleText: "Email verification required.",
//                            descriptionText: "Email is not verified. Please check your mail for verification or request a new verification email. Not really though!",
//                            gradientColor1: UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1),
//                            gradientColor2: UIColor(red: 9 / 255, green: 150 / 255, blue: 108 / 255, alpha: 1),
//                            startPoint: CGPoint(x: 0, y: 0.5),
//                            endPoint: CGPoint(x: 2, y: 0.5),
//                            titleFont: UIFont.systemFont(ofSize: 20, weight: .medium),
//                            descriptionFont: UIFont.systemFont(ofSize: 16, weight: .medium)
//                        )
//
//                        strongSelf.resendEmailButton.isHidden = false
//
//                    }
                }
                
                strongSelf.hideIndicator()
                
            }
            
        }
        
    }
    
    @objc private func signUpPressed() {
        
        print(#function)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController("SignUpViewController")
    }
    
    func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
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
