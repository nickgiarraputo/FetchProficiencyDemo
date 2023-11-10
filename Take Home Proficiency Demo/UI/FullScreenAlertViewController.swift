//
//  FullScreenAlertViewController.swift
//  Take Home Proficiency Demo
//
//  Created by Nick Giarraputo on 11/9/23.
//

import UIKit

enum FullScreenAlertActionStyle {
    case normal
    case cancel
    case destructive
}

struct FullScreenAlertAction {
    var title: String
    var style: FullScreenAlertActionStyle = .normal
    var action: ((FullScreenAlertAction) -> Void)
}

class FullScreenAlertViewController: UIViewController {
    
    var actions: [FullScreenAlertAction]?
    
    var fontRegular = UIFont.systemFont(ofSize: 17, weight: .regular)
    var fontBold = UIFont.systemFont(ofSize: 17, weight: .bold)
    
    var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 19, weight: .bold)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    var messageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .regular)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    init(title: String?, message: String?) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        view.isOpaque = true
        view.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white

        /// Styling
        titleLabel.font = fontBold.withSize(19)
        messageLabel.font = fontRegular.withSize(16)
        
        /// Add and constrain views
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(buttonsStackView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 350),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 350),
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonsStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 280),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
        
        /// Create a button for each action
        for action in actions ?? [] {
            let buttonTextSize: CGFloat = 17
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonsStackView.frame.width, height: 40))
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([ button.heightAnchor.constraint(equalToConstant: 40) ])
            button.setTitle(action.title, for: .normal)
            button.addTarget(self, action: #selector(actionPressed(_:)), for: .touchUpInside)
            button.titleLabel!.font = fontRegular.withSize(buttonTextSize)
            button.setTitleColor(traitCollection.userInterfaceStyle == .dark ? .white : .black, for: .normal)
            if action.style == .destructive {
                button.setTitleColor(.red, for: .normal)
            } else if action.style == .cancel {
                button.titleLabel!.font = fontBold.withSize(buttonTextSize)
            }
            button.layer.cornerRadius = button.frame.height / 2
            button.backgroundColor = UIColor(white: 0.5, alpha: 0.25)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    func addAction(_ action: FullScreenAlertAction) {
        if actions == nil {
            actions = [FullScreenAlertAction]()
        }
        actions!.append(action)
    }
    
    @objc func actionPressed(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        let action = actions?.first(where: { $0.title == button.titleLabel!.text })
        action?.action(action!)
    }
}
