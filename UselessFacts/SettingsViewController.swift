//
//  AboutViewController.swift
//  SynonymGen
//
//  Created by 梁程 on 2021/12/27.
//

import UIKit
import DynamicBottomSheet

class SettingsViewController: UIViewController {
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .firstBaseline
        sv.spacing = 16
        return sv
    }()
    
    let shareButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Share Us", for: .normal)
        btn.setTitleColor(UIColor(named: "text"), for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "ArialRoundedMTBold", size: 22)
        btn.layer.borderColor = K.brandYellow.cgColor
        btn.layer.borderWidth = 5
        btn.layer.cornerRadius = 12
        Tools.setWidth(btn, 250)
        Tools.setHeight(btn, 60)
        return btn
    }()
    
    let aboutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("About Us", for: .normal)
        btn.setTitleColor(UIColor(named: "text"), for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "ArialRoundedMTBold", size: 22)
        btn.layer.borderColor = K.brandYellow.cgColor
        btn.layer.borderWidth = 5
        btn.layer.cornerRadius = 12
        Tools.setWidth(btn, 250)
        Tools.setHeight(btn, 60)
        return btn
    }()
    
    @objc func shareButtonPressed(sender: UIButton){
        sender.showAnimation {
            let text = "Useless Facts"
            Tools.Vibration.success.vibrate()
            
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            

            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    @objc func aboutUsButtonPressed(sender: UIButton){
        sender.showAnimation {
            let bottomSheetView = AboutUsBottomSheet()
            self.present(bottomSheetView, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        shareButton.addTarget(self, action: #selector(shareButtonPressed(sender:)), for: .touchUpInside)
        aboutButton.addTarget(self, action: #selector(aboutUsButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        buttonStackView.addArrangedSubview(shareButton)
        buttonStackView.addArrangedSubview(aboutButton)
    }
}


class AboutUsBottomSheet: DynamicBottomSheetViewController{
    
    let logoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Useless\nFacts"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 25)
        lbl.layer.borderWidth = 8
        lbl.layer.cornerRadius = 15
        lbl.layer.borderColor = K.brandYellow.cgColor
        Tools.setHeight(lbl, 150)
        Tools.setWidth(lbl, 150)
        
        return lbl
    }()
    
    let versionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Version 1.0.0"
        lbl.textColor = UIColor(named: "text")
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 25)
        return lbl
    }()
    
    override func configureView() {
        super.configureView()
        
        let dragHandle = Tools.setUpDragHandle(color: .darkGray, width: 50, height: 12, radius: 6)
        contentView.addSubview(dragHandle)
        dragHandle.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(8)
        }
        
        Tools.setHeight(contentView, 300)
        contentView.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
        
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-15)
        }
    }
    
}
