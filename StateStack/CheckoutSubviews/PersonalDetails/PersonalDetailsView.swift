//
//  PersonalDetailsView.swift
//  StateStack
//
//  Created by Raghav on 10/02/21.
//

import Foundation
import UIKit

class PersonalDetailsView: StateStackSubview {
    var viewModel: MockViewModel?
    
    let expandedPersonalDetailsView: ExpandedMockView = {
        let expandedView = ExpandedMockView()
        expandedView.translatesAutoresizingMaskIntoConstraints = false
        
        return expandedView
    }()
    
    let collapsedPersonalDetailsView: CollapsedMockView = {
        let collapsedView = CollapsedMockView()
        collapsedView.translatesAutoresizingMaskIntoConstraints = false
        
        return collapsedView
    }()
    
    override var expandedView: UIView {
        return expandedPersonalDetailsView
    }
    
    override var collapsedView: UIView {
        return collapsedPersonalDetailsView
    }
    
    override init(ctaTitle: String, backgroundColor: UIColor, ctaContainerColor: UIColor) {
        super.init(ctaTitle: ctaTitle, backgroundColor: backgroundColor, ctaContainerColor: ctaContainerColor)
        
        let firstTitle = "First Name"
        let secondTitle = "Last Name"
        
        expandedPersonalDetailsView.setTitle((firstTitle, secondTitle))
        collapsedPersonalDetailsView.setTitle((firstTitle, secondTitle))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillExpand(direction: State.ExpandingDirection) {
        super.viewWillExpand(direction: direction)
        
        expandedView.alpha = 0.0
    }

    override func viewDidExpand(direction: State.ExpandingDirection) {
        super.viewDidExpand(direction: direction)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.expandedView.alpha = 1.0
                       })
        setupCTA()
    }

    override func viewWillCollapse() {
        super.viewWillCollapse()
        
        collapsedView.alpha = 0.0
    }
    
    override func setupCollapsedView() {
        super.setupCollapsedView()
        
        let viewModel = expandedPersonalDetailsView.getViewModel()
        collapsedPersonalDetailsView.setViewModel(with: viewModel)
        self.viewModel = viewModel
    }
    
    override func viewDidCollapse() {
        super.viewDidCollapse()
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.collapsedView.alpha = 1.0
                       })
    }
    
    private func setupCTA() {
        delegate?.setCTATitle(ctaTitle, for: .normal)
        delegate?.setCTAContainerColor(ctaContainerColor)
        delegate?.setCTATitleColor(UIColor.white, for: .normal)
        delegate?.setCTATitleColor(UIColor.white.withAlphaComponent(0.75), for: .highlighted)
    }
}
