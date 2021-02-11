//
//  ExpandedPersonalDetailsView.swift
//  StateStack
//
//  Created by Raghav on 10/02/21.
//

import Foundation
import UIKit

struct MockViewModel {
    let firstName: String
    let lastName: String
    
    public init(firstName: String?, lastName: String?) {
        self.firstName = firstName ?? ""
        self.lastName = lastName ?? ""
    }
}

class ExpandedMockView: UIView {
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .white
        
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .white
        
        return label
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    override class var requiresConstraintBasedLayout: Bool { true }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(firstNameLabel)
        addSubview(firstNameTextField)
        addSubview(lastNameLabel)
        addSubview(lastNameTextField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setupConstraints()
        
        super.updateConstraints()
    }
    
    private func setupConstraints() {
        firstNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24.0).isActive = true
        firstNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0).isActive = true
        firstNameLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -16.0).isActive = true
        
        firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 4.0).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0).isActive = true
        
        lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 12.0).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0).isActive = true
        lastNameLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -16.0).isActive = true
        
        lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 4.0).isActive = true
        lastNameTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0).isActive = true
        lastNameTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24.0).isActive = true
    }
    
    public func getViewModel() -> MockViewModel {
        return .init(firstName: firstNameTextField.text, lastName: lastNameTextField.text)
    }
    
    public func setTitle(_ titles: (String, String)) {
        firstNameLabel.text = titles.0
        lastNameLabel.text = titles.1
    }
}
