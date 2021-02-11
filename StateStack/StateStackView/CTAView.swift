//
//  CTAView.swift
//  StateStack
//
//  Created by Raghav on 10/02/21.
//

import Foundation
import UIKit

class CTAView: UIView {
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 24.0
        
        return containerView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        containerView.addSubview(button)
        button.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    public func addTapAction(_ action: UIAction) {
        button.addAction(action, for: .touchUpInside)
    }
    
    public func setContainerColor(_ color: UIColor?) {
        containerView.backgroundColor = color
    }
    
    public func setTitle(_ text: String?, for state: UIControl.State) {
        button.setTitle(text, for: state)
    }
    
    public func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        button.setTitleColor(color, for: state)
    }
}
