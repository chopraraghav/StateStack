//
//  StateStackView.swift
//  StateStack
//
//  Created by Raghav on 09/02/21.
//

import Foundation
import UIKit

protocol StateStackViewDelegate: AnyObject {
    func allViewsTraversed()
}

class StateStackView: UIView {
    weak var delegate: StateStackViewDelegate?
    
    private let stackSubviews: [StateStackSubview]
    
    private let ctaView: CTAView = {
        let ctaView = CTAView()
        ctaView.translatesAutoresizingMaskIntoConstraints = false
        
        return ctaView
    }()
    
    private var currentlyActiveIndex: Int?
    
    // MARK: - Interface
    
    public init(with subviews: [StateStackSubview]) {
        self.stackSubviews = subviews
        
        super.init(frame: .zero)
        
        self.backgroundColor = .black
        
        setupCTAView()
    }
    
    public func startTraversal() {
        self.moveToView(at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    
    private func addStackSubview(_ currentSubview: StateStackSubview, previousSubview: StateStackSubview?) {
        func setupSubviewConstraints(_ currentSubview: StateStackSubview, previousSubview: StateStackSubview?) {
            if let previousSubview = previousSubview {
                currentSubview.topAnchor.constraint(equalTo: previousSubview.customBottomAnchor).isActive = true
            } else {
                currentSubview.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
            }
            currentSubview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            currentSubview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            currentSubview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        guard currentSubview.superview == nil else { return }
        
        insertSubview(currentSubview, belowSubview: ctaView)
        setupSubviewConstraints(currentSubview, previousSubview: previousSubview)
        
        currentSubview.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        currentSubview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupCTAView() {
        addSubview(ctaView)
        ctaView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        ctaView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        ctaView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        ctaView.addTapAction(UIAction { [weak self] _ in
            guard let sSelf = self else { return }
            if let currentlyActiveIndex = sSelf.currentlyActiveIndex {
                let currentlyActiveSubview = sSelf.stackSubviews[currentlyActiveIndex]
                currentlyActiveSubview.handleCTATap()
            }
        })
    }
    
    // MARK: - Tap Gesture
    
    @objc func tapAction(_ recognizer: UITapGestureRecognizer) {
        if let stackSubviewIndex = self.stackSubviews.firstIndex(where: { $0 === recognizer.view }) {
            moveToView(at: stackSubviewIndex)
        }
    }
    
    // MARK: - Helper Functions
    
    private func moveToView(at nextActiveIndex: Int) {
        guard nextActiveIndex != currentlyActiveIndex, nextActiveIndex < stackSubviews.count else { return }
        
        let nextActiveSubview = self.stackSubviews[nextActiveIndex]
        
        if let currentlyActiveIndex = currentlyActiveIndex {
            if nextActiveIndex > currentlyActiveIndex {
                let currentlyActiveSubview = self.stackSubviews[currentlyActiveIndex]
                handleForwardMove(nextSubview: nextActiveSubview, currentSubview: currentlyActiveSubview)
            } else {
                handleBackwardMove(nextSubview: nextActiveSubview)
            }
        } else {
            handleForwardMove(nextSubview: nextActiveSubview, currentSubview: nil)
        }
        
        self.currentlyActiveIndex = nextActiveIndex
    }
    
    private func handleForwardMove(nextSubview: StateStackSubview, currentSubview: StateStackSubview?) {
        addStackSubview(nextSubview, previousSubview: currentSubview)
        
        let expadingDirection = State.ExpandingDirection.bottomTop
        
        CATransaction.begin()
        
        currentSubview?.viewWillCollapse()
        nextSubview.viewWillExpand(direction: expadingDirection)
            
        currentSubview?.updateState(to: .collapse)
        nextSubview.updateState(to: .expand(expadingDirection))
        
        currentSubview?.viewDidCollapse()
        nextSubview.viewDidExpand(direction: expadingDirection)
        
        animateForwardMove(nextSubview)
        
        CATransaction.commit()
    }
    
    private func handleBackwardMove(nextSubview: StateStackSubview) {
        let expadingDirection = State.ExpandingDirection.topBottom
        
        CATransaction.begin()
        
        nextSubview.viewWillExpand(direction: expadingDirection)
        
        nextSubview.updateState(to: .expand(expadingDirection))
        
        nextSubview.viewDidExpand(direction: expadingDirection)
        
        animateBackwardMove(nextSubview)
        
        CATransaction.commit()
    }
    
    // MARK: - Animations
    
    private func animateForwardMove(_ nextSubview: StateStackSubview) {
        self.layoutIfNeeded()
        
        nextSubview.transform = .init(translationX: 0, y: self.bounds.maxY)
        UIView.animate(withDuration: 0.5) {
            nextSubview.transform = .identity
        }
    }
    
    private func animateBackwardMove(_ nextSubview: StateStackSubview) {
        self.layoutIfNeeded()

        if let nextIndex = self.stackSubviews.firstIndex(of: nextSubview) {
            for indexToRemove in (nextIndex + 1)..<self.stackSubviews.count {
                let subviewToRemove = self.stackSubviews[indexToRemove]
                UIView.animate(withDuration: 0.5, animations: {
                    subviewToRemove.transform = .init(translationX: 0, y: self.bounds.maxY)
                }, completion: { _ in
                    subviewToRemove.removeFromSuperview()
                })
            }
        }
    }
}

extension StateStackView: StateStackSubviewDelegate {
    func moveToNextView() {
        if let currentlyActiveIndex = self.currentlyActiveIndex {
            let nextActiveIndex = currentlyActiveIndex + 1
            if nextActiveIndex < self.stackSubviews.count {
                moveToView(at: nextActiveIndex)
            } else {
                delegate?.allViewsTraversed()
            }
        }
    }
    
    func setCTAContainerColor(_ color: UIColor?) {
        ctaView.setContainerColor(color)
    }
    
    func setCTATitle(_ text: String?, for state: UIControl.State) {
        ctaView.setTitle(text, for: state)
    }
    
    func setCTATitleColor(_ color: UIColor?, for state: UIControl.State) {
        ctaView.setTitleColor(color, for: state)
    }
}
