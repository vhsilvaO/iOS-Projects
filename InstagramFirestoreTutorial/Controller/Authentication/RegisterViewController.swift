//
//  RegisterViewController.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 17/10/22.
//

import UIKit

class RegisterViewController: UIViewController {
    // MARK: - Properties
    
    private var viewModel = RegisterViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?

    private let plushPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let imageButton = UIImage(imageLiteralResourceName: "plus_photo")
        button.setImage(imageButton, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePlushPhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let fullNameTextField = CustomTextField(placeholder: "Fullname")
    private let userNameTextField = CustomTextField(placeholder: "Username")

    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = CustomButton(placeholder: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?  ", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Helpers

    func configureUI() {
        configureGradientLayer()
        setupComponents()
    }
    
    func setupComponents() {
        view.addSubview(plushPhotoButton)
        plushPhotoButton.centerX(inView: view)
        plushPhotoButton.setDimensions(height: 140, width: 140)
        plushPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        setupStackView()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, userNameTextField, emailTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: plushPhotoButton.bottomAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingTop: 32,
                        paddingLeft: 32,
                        paddingRight: 32)
    }
    
    func configureNotificationObservers() {
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == userNameTextField {
            viewModel.userName = sender.text
        } else if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
         updateForm()
    }
    
    @objc func handlePlushPhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        guard let profileImage = profileImage else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text?.lowercased() else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        let credentials = AuthCredentials(profileImage: profileImage,
                                       fullName: fullName,
                                       userName: userName,
                                       email: email,
                                       password: password)
        
        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                print("DEBUG: failed to register user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationDidComplete()
        }
    }
    
}

// MARK: - FormViewModel

extension RegisterViewController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.backgroundColorButton
        signUpButton.setTitleColor(viewModel.titleColorButton, for: .normal)
        signUpButton.isEnabled = viewModel.formatIsValid
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        plushPhotoButton.layer.cornerRadius = plushPhotoButton.frame.width / 2
        plushPhotoButton.layer.masksToBounds = true
        plushPhotoButton.layer.borderColor = UIColor.white.cgColor
        plushPhotoButton.layer.borderWidth = 2
        plushPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}
