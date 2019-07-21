//
//  ActionToolbar.swift
//  Bump
//
//  Created by Tim Wong on 7/19/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

protocol ActionToolbarDelegate: class {
    func actionToolbar(_ actionToolbar: ActionToolbar, didTap button: LoadingButton, at index: Int)
}

class ActionToolbar: UIView {
    var icons = [String]() {
        didSet {
            setupStackView()
        }
    }
    
    weak var delegate: ActionToolbarDelegate?
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var buttons = [LoadingButton]()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    init(icons: [String]) {
        self.icons = icons
        super.init(frame: .zero)
        setupStackView()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.Matcha.sky
        
        addSubview(stackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0))
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height * 0.50
    }
    
    private func setupStackView() {
        buttons.forEach { $0.removeFromSuperview(); stackView.removeArrangedSubview($0) }
        
        buttons = icons.enumerated().map { (index, icon) in
            let button = LoadingButton(type: .custom)
            button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            button.setTitle(icon, for: .normal)
            button.setTitleColor(UIColor.Matcha.dusk, for: .normal)
            button.titleLabel?.font = .featherFont(size: 24.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            if index == icons.count-1 {
                button.backgroundColor = UIColor.Matcha.dusk
                button.setTitleColor(UIColor.Matcha.sky, for: .normal)
                button.layer.cornerRadius = 14.0
            }
            
            return button
        }
        
        buttons.forEach { stackView.addArrangedSubview($0) }
        
        if let button = buttons.last {
            button.snp.makeConstraints { make in
                make.height.width.equalTo(28.0)
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: LoadingButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        
        delegate?.actionToolbar(self, didTap: sender, at: index)
    }
}
