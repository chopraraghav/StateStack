//
//  StateStackSubview.swift
//  StateStack
//
//  Created by Raghav on 10/02/21.
//

import Foundation
import UIKit

enum State {
    enum ExpandingDirection {
        case topBottom
        case bottomTop
    }
    
    case expand(ExpandingDirection)
    case collapse
}

protocol StateStackSubviewDelegate: AnyObject {
    func setCTAContainerColor(_ color: UIColor?)
    func setCTATitle(_ text: String?, for state: UIControl.State)
    func setCTATitleColor(_ color: UIColor?, for state: UIControl.State)
    func moveToNextView()
}

class StateStackSubview: UIView {
    weak var delegate: StateStackSubviewDelegate?
    
    // MARK: - Private Properties
    
    private(set) var state: State = .collapse {
        didSet {
            switch (oldValue, state) {
            case (.collapse, .expand(let direction)):
                setupExpandedView(direction: direction)
            case (.expand, .collapse):
                setupCollapsedView()
            default: ()
            }
        }
    }
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        return containerView
    }()
    
    private var _expandedView: UIView { expandedView! }
    private var _collapsedView: UIView { collapsedView! }
    
    private var expandedViewHeightConstraint: NSLayoutConstraint?
    private var collapsedViewHeightConstraint: NSLayoutConstraint?
    
    final var customBottomAnchor: NSLayoutYAxisAnchor {
        return _collapsedView.bottomAnchor
    }
    
    // MARK: - Overridable Properties
    
    open var expandedView: UIView? { nil }
    open var collapsedView: UIView? { nil }
    
    open var ctaTitle: String {
        didSet {
            if ctaTitle != oldValue {
                delegate?.setCTATitle(ctaTitle, for: .normal)
            }
        }
    }
    
    open var ctaContainerColor: UIColor {
        didSet {
            if ctaContainerColor != oldValue {
                delegate?.setCTAContainerColor(ctaContainerColor)
            }
        }
    }
    
    public init(ctaTitle: String,
                backgroundColor: UIColor,
                ctaContainerColor: UIColor) {
        self.ctaTitle = ctaTitle
        self.ctaContainerColor = ctaContainerColor
        
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        
        configureViews()
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateState(to newState: State) {
        self.state = newState
    }
    
    private func configureViews() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        containerView.addSubview(_expandedView)
        _expandedView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        _expandedView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        _expandedView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        expandedViewHeightConstraint = _expandedView.heightAnchor.constraint(equalToConstant: 0.0)
        
        containerView.addSubview(_collapsedView)
        _collapsedView.topAnchor.constraint(equalTo: _expandedView.bottomAnchor).isActive = true
        _collapsedView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        _collapsedView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        collapsedViewHeightConstraint = _collapsedView.heightAnchor.constraint(equalToConstant: 0.0)
        _collapsedView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor).isActive = true
    }
    
    private func configureStyle() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 24.0
        
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 8.0
    }
    
    // MARK: Overridable Functions
    
    open func setupExpandedView(direction: State.ExpandingDirection) {
        expandedViewHeightConstraint?.isActive = false
        collapsedViewHeightConstraint?.isActive = true
    }
    
    open func setupCollapsedView() {
        expandedViewHeightConstraint?.isActive = true
        collapsedViewHeightConstraint?.isActive = false
    }
    
    open func viewWillExpand(direction: State.ExpandingDirection) {
        _collapsedView.alpha = 0.0
        _expandedView.alpha = 1.0
    }
    
    open func viewDidExpand(direction: State.ExpandingDirection) {
        layoutIfNeeded()
    }
    
    open func viewWillCollapse() {
        _expandedView.alpha = 0.0
        _collapsedView.alpha = 1.0
    }
    
    open func viewDidCollapse() {
        layoutIfNeeded()
    }
    
    open func handleCTATap() {
        delegate?.moveToNextView()
    }
}

