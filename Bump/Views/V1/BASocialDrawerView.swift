//
//  BASocialDrawerView.swift
//  Bump
//
//  Created by Tim Wong on 8/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class BASocialDrawerView: UIView {
    var selectCallback: BASocialHandler?
    var items = [(AccountContact, String)]() {
        didSet {
            addSocialButtons()
        }
    }
    
    var socialViews = [UIButton]()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var scale: CGFloat = 1.0
    
    private var didSetupInitialConstraints = false
    
    //rx
    private var disposables = CompositeDisposable()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    init(scale: CGFloat) {
        self.scale = scale
        super.init(frame: .zero)
        commonInit()
    }
    
    init(items: [(AccountContact, String)], scale: CGFloat = 1.0) {
        self.items = items
        self.scale = scale
        super.init(frame: .zero)
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
    
    deinit {
        disposables.dispose()
    }
    
    private func commonInit() {
        addSubview(scrollView)
        addSocialButtons()
    }
    
    override func updateConstraints() {
        if !didSetupInitialConstraints {
            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(self)
            }
            
            didSetupInitialConstraints = true
        }
        
        for (index, holder) in socialViews.enumerated() {
            holder.snp.makeConstraints { make in
                make.centerY.equalTo(self.scrollView)
                make.height.width.equalTo(42.0*scale)
            }
            
            if index > 0 {
                holder.snp.makeConstraints { make in
                    make.leading.equalTo(self.socialViews[index-1].snp.trailing).offset(16.0*scale)
                }
            }
            else {
                holder.snp.makeConstraints { make in
                    make.leading.equalTo(self.scrollView)
                }
            }
            
            if index == (socialViews.count - 1) {
                holder.snp.makeConstraints { make in
                    make.trailing.lessThanOrEqualTo(self.scrollView)
                }
            }
        }
        
        super.updateConstraints()
    }
    
    private func addSocialButtons() {
        socialViews.forEach { $0.removeFromSuperview() }
        socialViews = []
        
        for (index, socialItem) in items.enumerated() {
            let button = UIButton(type: .custom)
            button.backgroundColor = socialItem.0.color
            button.setTitle(socialItem.0.icon, for: .normal)
            button.setTitleColor(.white, for: .normal)
            if let font = socialItem.0.font {
                button.titleLabel?.font = font.withSize(font.pointSize * scale)
            }
            button.layer.cornerRadius = (42.0 * scale) / 2.0
            button.translatesAutoresizingMaskIntoConstraints = false
            
            disposables += button.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.selectCallback?(strongSelf.items[index].0, strongSelf.items[index].1)
            }
            
            scrollView.addSubview(button)
            
            socialViews.append(button)
        }
        
        setNeedsUpdateConstraints()
    }
}
