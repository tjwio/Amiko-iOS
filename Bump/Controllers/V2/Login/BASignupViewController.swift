//
//  BASignupViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SkyFloatingLabelTextField

class BASignupViewController: UIViewController, UITextFieldDelegate {
    
    var firstName = MutableProperty<String?>(nil)
    var lastName = MutableProperty<String?>(nil)
    var phone = MutableProperty<String?>(nil)
    var email = MutableProperty<String?>(nil)
    var password = MutableProperty<String?>(nil)
    
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
    
    let firstNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.keyboardAppearance = .dark
        textField.keyboardType = .default
        textField.autocorrectionType = .default
        textField.spellCheckingType = .default
        textField.autocapitalizationType = .words
        textField.textColor = .white
        textField.font = UIFont.avenirRegular(size: 17.0)
        textField.iconFont = UIFont.featherFont(size: 17.0)
        textField.iconText = String.featherIcon(name: .user)
        textField.iconColor = .white
        textField.iconMarginBottom = 0.0
        textField.selectedIconColor = .white
        textField.placeholder = "First Name"
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
    
    let lastNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.keyboardAppearance = .dark
        textField.keyboardType = .default
        textField.autocorrectionType = .default
        textField.spellCheckingType = .default
        textField.autocapitalizationType = .words
        textField.textColor = .white
        textField.font = UIFont.avenirRegular(size: 17.0)
        textField.iconFont = UIFont.featherFont(size: 17.0)
        textField.iconText = String.featherIcon(name: .user)
        textField.iconColor = .white
        textField.iconMarginBottom = 0.0
        textField.selectedIconColor = .white
        textField.placeholder = "Last Name"
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
    
    let phoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.keyboardAppearance = .dark
        textField.keyboardType = .phonePad
        textField.autocorrectionType = .default
        textField.spellCheckingType = .default
        textField.autocapitalizationType = .words
        textField.textColor = .white
        textField.font = UIFont.avenirRegular(size: 17.0)
        textField.iconFont = UIFont.featherFont(size: 17.0)
        textField.iconText = String.featherIcon(name: .phone)
        textField.iconColor = .white
        textField.iconMarginBottom = 0.0
        textField.selectedIconColor = .white
        textField.placeholder = "Phone Number"
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
    
    let emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.keyboardAppearance = .dark
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.textColor = .white
        textField.font = UIFont.avenirRegular(size: 17.0)
        textField.iconFont = UIFont.featherFont(size: 17.0)
        textField.iconText = String.featherIcon(name: .mail)
        textField.iconColor = .white
        textField.iconMarginBottom = 0.0
        textField.selectedIconColor = .white
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
    
    let passwordTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.isSecureTextEntry = true
        textField.keyboardAppearance = .dark
        textField.textColor = .white
        textField.font = UIFont.avenirRegular(size: 17.0)
        textField.iconFont = UIFont.featherFont(size: 17.0)
        textField.iconText = String.featherIcon(name: .lock)
        textField.iconColor = .white
        textField.iconMarginBottom = 0.0
        textField.selectedIconColor = .white
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
    
    let createAccountButton: LoadingButton = {
        let button = LoadingButton(type: .custom)
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.isEnabled = false
        button.layer.cornerRadius = 27.0
        button.reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchUpInside.rawValue | UIControl.Event.touchUpOutside.rawValue | UIControl.Event.touchCancel.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.35)
        }
        
        button.reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchDown.rawValue | UIControl.Event.touchDragInside.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.50)
        }
        
        return button
    }()
    
    let loginButton: UIButton = {
        let loginAttString = NSMutableAttributedString(string: "Already have an account? Log in")
        loginAttString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(loginAttString.length-6, 6))
        loginAttString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, loginAttString.length))
        
        let button = UIButton(type: .custom)
        button.setAttributedTitle(loginAttString, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var textFieldsStackView: UIStackView!
    var fullStackView: UIStackView!
    
    private var isKeyboardShowing = false
    
    //rx
    private var disposables = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        firstName <~ firstNameTextField.reactive.continuousTextValues
        self.firstNameTextField.delegate = self
        self.firstNameTextField.addDoneToolbar(target: self, selector: #selector(self.userFinishedEditingFirstName(sender:)), toolbarStyle: .black)
        
        lastName <~ lastNameTextField.reactive.continuousTextValues
        self.lastNameTextField.delegate = self
        self.lastNameTextField.addDoneToolbar(target: self, selector: #selector(self.userFinishedEditingLastName(sender:)), toolbarStyle: .black)
        
        email <~ emailTextField.reactive.continuousTextValues
        self.emailTextField.delegate = self
        self.emailTextField.addDoneToolbar(target: self, selector: #selector(self.userFinishedEditingEmail(sender:)), toolbarStyle: .black)
        
        phone <~ phoneTextField.reactive.continuousTextValues
        self.phoneTextField.delegate = self
        self.phoneTextField.addDoneToolbar(target: self, selector: #selector(self.userFinishedEditingPhoneNumber(sender:)), toolbarStyle: .black)
        
        password <~ passwordTextField.reactive.continuousTextValues
        self.passwordTextField.delegate = self
        self.passwordTextField.addDoneToolbar(target: self, selector: #selector(self.userFinishedEditingPassword(sender:)), toolbarStyle: .black)
        
        textFieldsStackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, phoneTextField, passwordTextField])
        textFieldsStackView.alignment = .center
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fill
        textFieldsStackView.spacing = 10.0
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        fullStackView = UIStackView(arrangedSubviews: [textFieldsStackView, createAccountButton])
        fullStackView.alignment = .center
        fullStackView.axis = .vertical
        fullStackView.distribution = .fill
        fullStackView.spacing = 15.0
        fullStackView.translatesAutoresizingMaskIntoConstraints = false
        
        createAccountButton.addTarget(self, action: #selector(self.createAccount(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(self.goToLogin(_:)), for: .touchUpInside)
        
        view.addSubview(backgroundImageView)
        view.addSubview(ciaoLabel)
        view.addSubview(fullStackView)
        view.addSubview(loginButton)
        
        self.setupConstraints()
        
        _ = self.addBackButtonToView(dark: false)
        
        let producer = SignalProducer.combineLatest(firstName.producer, lastName.producer, phone.producer, email.producer, password.producer).map { (firstName, lastName, phone, email, password) -> Bool in
            let firstNameValid = firstName?.count ?? 0 > 0
            let lastNameValid = lastName?.count ?? 0 > 0
            let phoneValid = phone?.count ?? 0 > 0
            let emailValid = email?.count ?? 0 > 0 ? CommonUtility.isValidEmail(email!) : false
            let passwordValid = password?.count ?? 0 >= 6
            
            return firstNameValid && lastNameValid && phoneValid && emailValid && passwordValid
        }
        
        disposables += producer.startWithValues { [unowned self] isEnabled in
            if (isEnabled) {
                self.createAccountButton.isEnabled = true;
                self.createAccountButton.backgroundColor = self.createAccountButton.backgroundColor?.withAlphaComponent(0.35)
            }
            else {
                self.createAccountButton.isEnabled = false;
                self.createAccountButton.backgroundColor = self.createAccountButton.backgroundColor?.withAlphaComponent(0.1)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            make.leading.equalTo(self.view).offset(48.0)
            make.trailing.equalTo(self.view).offset(-48.0)
            make.centerY.equalTo(self.view)
        }
        
        firstNameTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(44.0)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(44.0)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(44.0)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(44.0)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(44.0)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.leading.equalTo(self.fullStackView)
            make.trailing.equalTo(self.fullStackView)
            make.height.equalTo(54.0)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-30.0)
            make.centerX.equalTo(self.view)
        }
    }
    
    //MARK: text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.emailTextField) {
            self.passwordTextField.becomeFirstResponder()
        }
        else if (textField == self.passwordTextField && self.createAccountButton.isEnabled) {
            createAccount(createAccountButton)
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let newText = (text as NSString).replacingCharacters(in: range, with: string);
            if let floatingTextField = textField as? SkyFloatingLabelTextField {
                if (newText.count == 0) {
                    floatingTextField.errorMessage = floatingTextField.placeholder?.uppercased();
                }
                else {
                    if (floatingTextField == self.emailTextField && !CommonUtility.isValidEmail(newText)) {
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
    
    @objc private func userFinishedEditingFirstName(sender: Any) {
        self.firstNameTextField.resignFirstResponder()
    }
    
    @objc private func userFinishedEditingLastName(sender: Any) {
        self.lastNameTextField.resignFirstResponder()
    }
    
    @objc private func userFinishedEditingPhoneNumber(sender: Any) {
        self.phoneTextField.resignFirstResponder()
    }
    
    @objc private func userFinishedEditingEmail(sender: Any) {
        self.emailTextField.resignFirstResponder()
    }
    
    @objc private func userFinishedEditingPassword(sender: Any) {
        self.passwordTextField.resignFirstResponder()
    }
    
    //MARK: create account
    @objc private func createAccount(_ sender: LoadingButton?) {
        sender?.isLoading = true
        AuthenticationManager.shared.signup(firstName: firstName.value!, lastName: lastName.value!, email: email.value!, phone: phone.value!, password: password.value!, success: { user in
            let homeBlock = {
                let viewController = BAFirstXPWelcomeViewController(user: user)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            user.loadShips(success: { _ in
                homeBlock()
            }, failure: { _ in
                homeBlock()
            })
        }) { error in
            print("failed to create account with error: \(error)")
            self.createAccountButton.isLoading = false
            self.showLeftMessage("Failed to create accout. Please try again", type: .error, options: [.height(66.0)])
        }
    }
    
    //MARK: login
    @objc private func goToLogin(_ sender: UIButton?) {
        let viewController = BALoginViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Keyboard Notifications
    
    @objc private func keyboardWillShow(notification: NSNotification?) {
        if (self.navigationController?.viewControllers.last == self && self.isViewLoaded && self.view.window != nil) {
            if (self.isKeyboardShowing) {
                return
            }
            
            if let keyboardFrame = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
    
    // MARK: status bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
}
