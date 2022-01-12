//
//  FactCell.swift
//  UselessFacts
//
//  Created by 梁程 on 2022/1/5.
//

import UIKit

class FactCell: UITableViewCell {
    
    var factText: String?
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.3
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor(named: "border")?.cgColor
        return view
    }()
    
    let factTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Studies have shown that children laugh an average of 300 times/day."
        tv.textColor = .black
        tv.textColor = UIColor(named: "text")
        tv.isScrollEnabled = false
        tv.font = UIFont.init(name: "ArialRoundedMTBold", size: 25)
        tv.isEditable = false
        tv.isSelectable = false
        return tv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView)
        }

        
        cardView.addSubview(factTextView)
        factTextView.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(16)
            make.left.equalTo(cardView).offset(16)
            make.right.equalTo(cardView).offset(-16)
            make.bottom.equalTo(cardView).offset(-16)
        }
        

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
