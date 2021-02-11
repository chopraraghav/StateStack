//
//  CollapsedPersonalDetailsView.swift
//  StateStack
//
//  Created by Raghav on 10/02/21.
//

import Foundation
import UIKit

class CollapsedMockView: UIView {
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .white
        
        return label
    }()
    
    let firstNameValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .white
        
        return label
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .white
        
        return label
    }()
    
    let lastNameValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = .white
        
        return label
    }()
    
    override class var requiresConstraintBasedLayout: Bool { true }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(firstNameLabel)
        addSubview(firstNameValue)
        addSubview(lastNameLabel)
        addSubview(lastNameValue)
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
        firstNameLabel.rightAnchor.constraint(equalTo: firstNameValue.rightAnchor).isActive = true
        
        firstNameValue.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 4.0).isActive = true
        firstNameValue.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0).isActive = true
        firstNameValue.rightAnchor.constraint(equalTo: lastNameValue.leftAnchor, constant: -16.0).isActive = true
        firstNameValue.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24.0).isActive = true
        
        lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.topAnchor).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: lastNameValue.leftAnchor).isActive = true
        lastNameLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -16.0).isActive = true
        
        lastNameValue.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 4.0).isActive = true
        lastNameValue.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -16.0).isActive = true
        lastNameValue.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24.0).isActive = true
    }
    
    public func setViewModel(with viewModel: MockViewModel) {
        firstNameValue.text = viewModel.firstName
        lastNameValue.text = viewModel.lastName
    }
    
    public func setTitle(_ titles: (String, String)) {
        firstNameLabel.text = titles.0
        lastNameLabel.text = titles.1
    }
}

