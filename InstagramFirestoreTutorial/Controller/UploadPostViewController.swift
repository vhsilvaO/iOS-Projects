//
//  UploadPostViewController.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 30/11/22.
//

import UIKit

protocol UploadPostViewControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostViewController)
}

class UploadPostViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: UploadPostViewControllerDelegate?
    
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    var currentUser: User?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var captionTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter caption..."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.placeholderShouldCenter = false
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        setupBackgroundColor()
        setupNavigationBarComponents()
        setupViewComponents()
    }
    
    func setupBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func setupNavigationBarComponents() {
        setupNavigationBarTitle()
        setupNavigationBarLeftItem()
        setupNavigationBarRightItem()
    }
    
    func setupNavigationBarTitle() {
        navigationItem.title = "Upload Post"
    }
    
    func setupNavigationBarLeftItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                    target: self,
                                                    action: #selector(didTapCancel))
    }
    
    func setupNavigationBarRightItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: .done,
                                                     target: self,
                                                            action: #selector(didTapDone))
    }
    
    func setupViewComponents() {
        setupPhotoConstraints()
        setupCaptionTextViewConstraints()
        setupCharacterCountLabelConstraints()
    }
    
    func setupPhotoConstraints() {
        view.addSubview(photoImageView)
        
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
    }
    
    func setupCaptionTextViewConstraints() {
        view.addSubview(captionTextView)
        
        captionTextView.anchor(top: photoImageView.bottomAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingTop: 16,
                            paddingLeft: 12,
                            paddingRight: 12,
                            height: 64)
    }
    
    func setupCharacterCountLabelConstraints() {
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor,
                               right: view.rightAnchor,
                               paddingRight: 12)
    }
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    //MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
        guard let selectedImage = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        
        showLoader(true)
        
        PostService.uploadPost(caption: caption, image: selectedImage, user: user) { error in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
                return
            }
            
            self.delegate?.controllerDidFinishUploadingPost(self)
        }

   }
}

//MARK: - UITextFieldDelegate

extension UploadPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
