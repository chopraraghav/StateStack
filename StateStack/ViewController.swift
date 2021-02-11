//
//  ViewController.swift
//  StateStack
//
//  Created by Raghav on 09/02/21.
//

import UIKit

class ViewController: UIViewController {
    struct Constants {
        static let personalDetailsBackground = UIColor(red: 38 / 255, green: 40 / 255, blue: 50 / 255, alpha: 1.0)
        static let deliveryAddressBackground = UIColor(red: 244 / 255, green: 178 / 255, blue: 109 / 255, alpha: 1.0)
        static let paymentMethodBackground = UIColor(red: 114 / 255, green: 204 / 255, blue: 174 / 255, alpha: 1.0)
    }
    
    let personalDetailsView: PersonalDetailsView = {
        let stackSubview = PersonalDetailsView(ctaTitle: "Next: Fill Delivery Address",
                                               backgroundColor: Constants.personalDetailsBackground,
                                               ctaContainerColor: Constants.deliveryAddressBackground)
        stackSubview.translatesAutoresizingMaskIntoConstraints = false
        
        return stackSubview
    }()
    
    let deliveryAddressView: DeliveryAddressView = {
        let stackSubview = DeliveryAddressView(ctaTitle: "Next: Choose a Payment Method",
                                               backgroundColor: Constants.deliveryAddressBackground,
                                               ctaContainerColor: Constants.paymentMethodBackground)
        stackSubview.translatesAutoresizingMaskIntoConstraints = false
        
        return stackSubview
    }()
    
    let paymentMethodView: PaymentMethodView = {
        let stackSubview = PaymentMethodView(ctaTitle: "Proceed to Checkout",
                                             backgroundColor: Constants.paymentMethodBackground,
                                             ctaContainerColor: UIColor.black)
        stackSubview.translatesAutoresizingMaskIntoConstraints = false
        
        return stackSubview
    }()
    
    lazy var stateStackView: StateStackView = {
        let subviews = [personalDetailsView, deliveryAddressView, paymentMethodView]
        let stackView = StateStackView(with: subviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(stateStackView)
        stateStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stateStackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stateStackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stateStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stateStackView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateStackView.startTraversal()
    }
}

extension ViewController: StateStackViewDelegate {
    func allViewsTraversed() {
        let alert = UIAlertController(title: "You've successfully checked out!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Start Over", style: .default, handler: { [weak self] _ in
            self?.stateStackView.startTraversal()
        }))
        self.present(alert, animated: true)
    }
}

