//
//  HomeViewController.swift
//  SynonymGen
//
//  Created by 梁程 on 2021/12/27.
//

import UIKit
import SnapKit
import KRProgressHUD

class HomeViewController: UIViewController {
    let headingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Useless fact\nof the day"
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 30)
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    let cardView: UIView = {
        let view = UIView()
        Tools.setWidth(view, 300)
        view.layer.borderColor = UIColor(named: "border")?.cgColor
        view.layer.borderWidth = 0.6
        view.layer.cornerRadius = 20
        return view
    }()
    
    let factTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor(named: "text")
        tv.isScrollEnabled = false
        tv.font = UIFont.init(name: "ArialRoundedMTBold", size: 25)
        tv.isEditable = false
        tv.isSelectable = false
        return tv
    }()
    
    var factData: FactData?
    func GetARandomFact(onCompletion:@escaping () -> ()){
        let urlString = "https://uselessfacts.jsph.pl/today.json?language=en"
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { [self]data, response, error in
            if error == nil {
                do{
                    self.factData = try JSONDecoder().decode(FactData.self, from: data!)
                    DispatchQueue.main.async {
                        onCompletion()
                    }
                }catch{
                    //print(error)
                }
            }
        }).resume()
    }
    
    
    @objc func saveCompleted(_ image: UIImage,
        didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {
            print("ERROR: \(error)")
        }else {
            KRProgressHUD.showMessage("Saved to album")
        }
    }
   
   func writeToPhotoAlbum(image: UIImage) {
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
     }
    
    
    let downloadButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.down.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        Tools.setWidth(btn, 70)
        Tools.setHeight(btn, 70)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        return btn
    }()
    
    let shareButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.up.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        
        Tools.setWidth(btn, 70)
        Tools.setHeight(btn, 70)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        return btn
    }()
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        Tools.setWidth(sv, 180)
        return sv
    }()
    
    @objc func downloadButtonPressed(sender: UIButton){
        sender.showAnimation { [self] in
            let image =  captureView(view: factTextView)
            self.writeToPhotoAlbum(image: image)
            Tools.Vibration.success.vibrate()
        }
    }
    
    
    @objc func shareButtonPressed(sender: UIButton){
        sender.showAnimation { [self] in
            Tools.Vibration.success.vibrate()
            let image = captureView(view: self.factTextView)
            let imageToShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    func captureView(view: UIView) -> UIImage {
        var screenRect: CGRect = view.bounds
        UIGraphicsBeginImageContext(screenRect.size)
        UIGraphicsBeginImageContextWithOptions(screenRect.size, true, 0)
        var ctx: CGContext = UIGraphicsGetCurrentContext()!
        UIColor.black.set()
        ctx.fill(screenRect)
        view.layer.render(in: ctx)
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        GetARandomFact { [self] in
            factTextView.text = factData?.text
        }
        
        downloadButton.addTarget(self, action: #selector(downloadButtonPressed(sender:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonPressed(sender:)), for: .touchUpInside)
        
        view.addSubview(headingLabel)
        headingLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(130)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(20)
        }

        
        cardView.addSubview(factTextView)
        factTextView.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(16)
            make.left.equalTo(cardView).offset(16)
            make.right.equalTo(cardView).offset(-16)
            make.bottom.equalTo(cardView).offset(-16)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-60)
        }
        
        buttonStackView.addArrangedSubview(downloadButton)
        buttonStackView.addArrangedSubview(shareButton)
    }
}
