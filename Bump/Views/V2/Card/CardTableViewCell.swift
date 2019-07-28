//
//  CardTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 7/27/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class CardTableViewCell: UITableViewCell {
    var cards = [Card]() {
        didSet {
            updateCards(cards)
        }
    }
    
    var cardViews = [CardView]()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(scrollView)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    private func updateCards(_ cards: [Card]) {
        cardViews.forEach { $0.removeFromSuperview() }
        
        cardViews = cards.map { card in
            let view = CardView()
            view.nameLabel.text = card.name
            view.numberLabel.text = "#\(String(card.id[card.id.index(card.id.endIndex, offsetBy: -4) ..< card.id.endIndex]))"
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        var previousView: CardView?
        
        cardViews.forEach { cardView in
            scrollView.addSubview(cardView)
            
            cardView.snp.makeConstraints { make in
                if let previousView = previousView {
                    make.leading.equalTo(previousView.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                
                make.centerY.width.equalToSuperview()
                make.height.equalTo(182.0)
            }
            
            previousView = cardView
        }
        
        previousView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
    }
}
