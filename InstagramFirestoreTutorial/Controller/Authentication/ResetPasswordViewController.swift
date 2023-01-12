//
//  ResetPasswordViewController.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 15/12/22.
//

import UIKit

protocol ResetPasswordViewControllerDelegate: AnyObject {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordViewController)
}

class ResetPasswordViewController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = ResetPasswordViewModel()
    weak var delegate: ResetPasswordViewControllerDelegate?
    var email: String?
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = CustomButton(placeholder: "Reset Password")
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
    }
    
    //MARK: - Components
    
    func configureUI() {
        configureGradientLayer()
        setupStackView()
        setupBackButtonConstraints()
        setupIconImageConstraints()
        setupEmailTextFieldTarget()
        setupEmailProperty()
    }
    
    func setupBackButtonConstraints() {
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.leftAnchor,
                       paddingTop: 16,
                       paddingLeft: 16)
    }
    
    func setupIconImageConstraints() {
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
    }
    
    func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingTop: 32,
                        paddingLeft: 32,
                        paddingRight: 32)
    }
    
    //MARK: - Helpers
    
    func setupEmailTextFieldTarget() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func setupEmailProperty() {
        emailTextField.text = email
        viewModel.email = email
        updateForm()
    }
    
    //MARK: - Actions
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { error in
            if let error = error {
                self.showLoader(false)
    
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }
            
            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        
        updateForm()
    }
}

extension ResetPasswordViewController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.backgroundColorButton
        resetPasswordButton.setTitleColor(viewModel.titleColorButton, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formatIsValid
    }
}
