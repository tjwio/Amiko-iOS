//
//  BALoginViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SkyFloatingLabelTextField

class BALoginViewController: UIViewController, UITextFieldDelegate {
    
    let ciaoLabel: UILabel = {
        let label = UILabel()
        label.text = "Ciao."
        label.textColor = .white
        label.font = UIFont.avenirBold(size: 60.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .launchImageBg)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Create an account to get started"
        label.textColor = .white
        label.font = UIFont.avenirDemi(size: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let emailTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.keyboardAppearance = .dark
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.textColor = .white
        textField.font = UIFont.avenirRegular(size: 17.0)
        textField.placeholder = "Email"
        textField.placeholderColor = .white
        textField.placeholderFont = UIFont.avenirRegular(size: 17.0)
        textField.titleLabel.font = UIFont.avenirRegular(size: 12.0)
        textField.lineColor = UIColor(hexColor: 0xAAB2BD)
        textField.titleColor = UIColor(hexColor: 0xAAB2BD)
        textField.selectedLineColor = UIColor(hexColor: 0x2895F1)
        textField.selectedTitleColor = .white
        textField.errorColor = UIColor(hexColor: 0xED5565)
        textField.lineHeight = 0.5
        textField.selectedLineHeight = 0.5
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let passwordTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.isSecureTextEntry = true
        textField.keyboardAppearance = .dark
        textField.textColor = .white
        textField.font = UIFont.avenirRegular(size: 17.0)
        textField.placeholder = "Password"
        textField.placeholderColor = .white
        textField.placeholderFont = UIFont.avenirRegular(size: 17.0)
        textField.lineColor = UIColor(hexColor: 0xAAB2BD)
        textField.titleColor = UIColor(hexColor: 0xAAB2BD)
        textField.titleLabel.font = UIFont.avenirRegular(size: 12.0)
        textField.selectedLineColor = UIColor(hexColor: 0x2895F1)
        textField.selectedTitleColor = .white
        textField.errorColor = UIColor(hexColor: 0xED5565)
        textField.lineHeight = 0.5
        textField.selectedLineHeight = 0.5
        textField.addShowButton()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let loginButton: BALoadingButton = {
        let button = BALoadingButton(type: .custom)
        button.backgroundColor = UIColor(hexColor: 0x2895F1)
        button.setTitle("SIGN IN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.layer.cornerRadius = 4.0
        button.reactive.controlEvents(UIControlEvents(rawValue: UIControlEvents.touchUpInside.rawValue | UIControlEvents.touchUpOutside.rawValue | UIControlEvents.touchCancel.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(1.0)
        }
        
        button.reactive.controlEvents(UIControlEvents(rawValue: UIControlEvents.touchDown.rawValue | UIControlEvents.touchDragInside.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.9)
        }
        
        return button
    }()
    
    let createAccountButton: UIButton = {
        let createAccountAttString = NSMutableAttributedString(string: "Dont have an account? Create Account")
        createAccountAttString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(createAccountAttString.length-14, 14))
        createAccountAttString.addAttribute(.foregroundColor, value: UIColor.white, range: NSMakeRange(0, createAccountAttString.length))
        
        let button = UIButton(type: .custom)
        button.setAttributedTitle(createAccountAttString, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let forgotPasswordAttString = NSAttributedString(string: "Forgot Password?", attributes: [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                                                                                  NSAttributedStringKey.foregroundColor : UIColor.white])
        let button = UIButton(type: .custom)
        button.setAttributedTitle(forgotPasswordAttString, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 16.0)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var textFieldsStackView: UIStackView!
    var fullStackView: UIStackView!
    
    private var isKeyboardShowing: Bool! = false
    
    //rx
    private var disposables = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        emailTextField.delegate = self
        emailTextField.addDoneToolbar(target: self, selector: #selector(self.userFinishedEditingEmail(sender:)), toolbarStyle: .black)
        
        passwordTextField.delegate = self
        passwordTextField.addDoneToolbar(target: self, selector: #selector(self.userFinishedEditingPassword(sender:)), toolbarStyle: .black)
        
        textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        textFieldsStackView.alignment = .center
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fill
        textFieldsStackView.spacing = 10.0
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStackView = UIStackView(arrangedSubviews: [loginButton, forgotPasswordButton])
        buttonStackView.alignment = .center
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fill
        buttonStackView.spacing = 10.0
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        fullStackView = UIStackView(arrangedSubviews: [infoLabel, textFieldsStackView, buttonStackView])
        fullStackView.alignment = .center
        fullStackView.axis = .vertical
        fullStackView.distribution = .fill
        fullStackView.spacing = 15.0
        fullStackView.translatesAutoresizingMaskIntoConstraints = false
        
        createAccountButton.addTarget(self, action: #selector(self.goToCreateAccount(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(self.login(_:)), for: .touchUpInside)
        
        view.addSubview(backgroundImageView)
        view.addSubview(ciaoLabel)
        view.addSubview(fullStackView)
        view.addSubview(createAccountButton)
        
        setupConstraints()
        
        _ = self.addBackButtonToView(dark: false)
        
        let emailTextFieldSignal = self.emailTextField.reactive.continuousTextValues
        let passwordTextFieldSignal  = self.passwordTextField.reactive.continuousTextValues
        
        self.disposables += Signal.combineLatest(emailTextFieldSignal, passwordTextFieldSignal).map { email, password in
            return (email != nil ? BACommonUtility.isValidEmail(email!) : false) && (password?.count ?? 0 > 0);
            }.observeValues { [weak self] isEnabled in
                guard let strongSelf = self else { return }
                if (isEnabled) {
                    strongSelf.loginButton.isEnabled = true;
                    strongSelf.loginButton.backgroundColor = strongSelf.loginButton.backgroundColor?.withAlphaComponent(1.0)
                }
                else {
                    strongSelf.loginButton.isEnabled = false;
                    strongSelf.loginButton.backgroundColor = strongSelf.loginButton.backgroundColor?.withAlphaComponent(0.5)
                }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        ciaoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.fullStackView.snp.top).offset(-50.0)
            make.centerX.equalTo(self.view)
        }
        
        fullStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(16.0)
            make.trailing.equalTo(self.view).offset(-16.0)
            make.centerY.equalTo(self.view)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(44.0)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(44.0)
        }
        
        loginButton.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(48.0)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-30.0)
            make.centerX.equalTo(self.view)
        }
    }
    
    //MARK: text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.emailTextField) {
            self.passwordTextField.becomeFirstResponder();
        }
        else if (textField == self.passwordTextField && self.loginButton.isEnabled) {
            login(nil);
        }
        else {
            textField.resignFirstResponder();
        }
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let newText = (text as NSString).replacingCharacters(in: range, with: string);
            if let floatingTextField = textField as? SkyFloatingLabelTextField {
                if (newText.count == 0) {
                    floatingTextField.errorMessage = floatingTextField.placeholder?.uppercased();
                }
                else {
                    if (floatingTextField == self.emailTextField && !BACommonUtility.isValidEmail(newText)) {
                        floatingTextField.errorMessage = "EMAIL NOT VALID";
                    }
                    else {
                        floatingTextField.errorMessage = "";
                    }
                }
            }
        }
        return true;
    }
    
    @objc private func userFinishedEditingEmail(sender: Any) {
        self.emailTextField.resignFirstResponder()
    }
    
    @objc private func userFinishedEditingPassword(sender: Any) {
        self.passwordTextField.resignFirstResponder()
    }
    
    //MARK: login
    @objc private func login(_ sender: UIButton?) {
        BAAuthenticationManager.shared.login(email: self.emailTextField.text!, password: self.passwordTextField.text!, success: { user in
            let homeBlock = {
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as? AppDelegate)?.loadHomeViewController(user: user)
                }
            }
            
            user.loadHistory(success: { _ in
                homeBlock()
            }, failure: { _ in
                homeBlock()
            })
        }) { error in
            print("failed to login with error: \(error)")
            self.loginButton.isLoading = false
            self.showLeftMessage("Failed to login. Please try again", type: .error, options: [.height(66.0)])
        }
    }
    
    //MARK: signup
    
    @objc private func goToCreateAccount(_ sender: UIButton?) {
        let viewController = BASignupViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: Keyboard Notifications
    @objc private func keyboardWillShow(notification: NSNotification?) {
        if (self.navigationController?.viewControllers.last == self && self.isViewLoaded && self.view.window != nil) {
            if (self.isKeyboardShowing) {
                return
            }
            
            if let keyboardFrame = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let offset = (self.fullStackView.frame.origin.y + self.textFieldsStackView.frame.origin.y + self.textFieldsStackView.frame.size.height + 30.0) - keyboardFrame.origin.y;
                if (offset > 0) {
                    self.fullStackView.snp.updateConstraints { make in
                        make.centerY.equalTo(self.view).offset(-(offset+40.0))
                    }
                    self.view.setNeedsUpdateConstraints();
                    UIView.animate(withDuration: 0.1, animations: {
                        self.view.layoutIfNeeded();
                    });
                    
                    self.isKeyboardShowing = true;
                }
            };
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification?) {
        if (self.navigationController?.viewControllers.last == self && self.isViewLoaded && self.view.window != nil) {
            self.fullStackView.snp.updateConstraints { make in
                make.centerY.equalTo(self.view)
            }
            self.view.setNeedsUpdateConstraints();
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded();
            });
            
            self.isKeyboardShowing = false;
        }
    }
    
    //MARK: status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
}
