//
//  FactsListViewController.swift
//  UselessFacts
//
//  Created by 梁程 on 2021/12/27.
//

import UIKit
import DynamicBottomSheet
import AVFoundation
import KRProgressHUD

class FactsListViewController: UIViewController{
    
    var factData: FactData?
    static var factArray: [String] = []
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        return rc
    }()


    func GetARandomFact(onCompletion:@escaping () -> ()){
        let urlString = "https://uselessfacts.jsph.pl/random.json?language=en"
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { [self]data, response, error in
            if error == nil {
                do{
                    self.factData = try JSONDecoder().decode(FactData.self, from: data!)
                    FactsListViewController.factArray.append(factData!.text)
                    
                    DispatchQueue.main.async {
                        onCompletion()
                    }
                }catch{
                    //print(error)
                }
            }
        }).resume()
    }
    
    func GetRandomFacts(numOfTimes: Int, onCompletion:@escaping () -> ()){
        for _ in 0..<numOfTimes{
            GetARandomFact {
                self.factTableView.reloadData()
 
            }
        }
        DispatchQueue.main.async {
            onCompletion()
        }
        
    }
    
    
    
    let factTableView: UITableView = {
        let tv = UITableView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 200
        tv.backgroundColor = .clear
        tv.rowHeight = UITableView.automaticDimension
    
        return tv
    }()
        
    @objc func longPressCell(sender: UILongPressGestureRecognizer) {

            if sender.state == UIGestureRecognizer.State.began {
                let touchPoint = sender.location(in: factTableView)
                if let indexPath = factTableView.indexPathForRow(at: touchPoint) {
                    
                    let gen = UIImpactFeedbackGenerator(style: .heavy)
                    gen.impactOccurred()
                    
                    
                    let bottomSheet = longPressBottomSheet()
                    bottomSheet.index = indexPath[1]
                    self.present(bottomSheet, animated: true, completion: nil)
                }
            }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        GetRandomFacts(numOfTimes: 10) {
            self.refreshControl.endRefreshing()
            KRProgressHUD.showMessage("Updated 10 useless facts")
        }
         
        self.factTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Facts"
        factTableView.register(FactCell.self, forCellReuseIdentifier: "FactCell")
        factTableView.delegate = self
        factTableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        factTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        GetRandomFacts(numOfTimes: 10) {
        
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(sender:)))
        factTableView.addGestureRecognizer(longPress)
        
        
        view.addSubview(factTableView)
        factTableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}

extension FactsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FactsListViewController.factArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactCell", for: indexPath) as! FactCell
        cell.factTextView.text = FactsListViewController.factArray.reversed()[indexPath.row]
        cell.selectionStyle = .none

        
        return cell
    }
}



class longPressBottomSheet: DynamicBottomSheetViewController {
    
    var imageToSave: UIImage?
    var index: Int?
    let factTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .black
        tv.isScrollEnabled = false
        tv.font = UIFont.init(name: "ArialRoundedMTBold", size: 18)
        tv.textColor = UIColor(named: "text")
        tv.isEditable = false
        tv.isSelectable = false
        tv.backgroundColor = UIColor(named: "background")
        return tv
    }()
    
    
    @objc func saveCompleted(_ image: UIImage,
        didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {
            print("ERROR: \(error)")
        }else {
//            KRProgressHUD.showMessage("Saved to album")
        }
    }
   
   func writeToPhotoAlbum(image: UIImage) {
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
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

    @objc func downloadButtonPressed(sender: UIButton){
        sender.showAnimation { [self] in
            let image =  captureView(view: factTextView)
            self.writeToPhotoAlbum(image: image)
            Tools.Vibration.success.vibrate()
            sender.setTitle("Done", for: .normal)
            sender.setBackgroundColor(color: K.brandGreen, forState: .disabled)
            sender.isEnabled = false
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
   
    
    override func configureView() {
        super.configureView()
        
        let cardView: UIView = {
            let view = UIView()
            view.layer.borderWidth = 0.3
            view.layer.cornerRadius = 20
            return view
        }()
        contentView.backgroundColor = UIColor(named: "background")

        
        factTextView.text = FactsListViewController.factArray.reversed()[index!]
        
        
        let downloadButton = Tools.setUpButton("Save to album", K.brandGreen, 20, Int(K.screenWidth) - 50, 45, .semibold)
        downloadButton.addTarget(self, action: #selector(downloadButtonPressed(sender:)), for: .touchUpInside)
        downloadButton.layer.cornerRadius = 6
        downloadButton.titleLabel?.font = UIFont.init(name: "ArialRoundedMTBold", size: 18)
        
        
        let shareButton = Tools.setUpButton("Share this fact", K.brandRed, 20, Int(K.screenWidth) - 50, 45, .semibold)
        shareButton.addTarget(self, action: #selector(shareButtonPressed(sender:)), for: .touchUpInside)
        shareButton.layer.cornerRadius = 6
        shareButton.titleLabel?.font = UIFont.init(name: "ArialRoundedMTBold", size: 18)
        
        
        contentView.heightAnchor.constraint(equalToConstant: 460).isActive = true
        let dragButton = Tools.setUpDragHandle(color: UIColor.darkGray, width: 50, height: 12, radius: 6)
        contentView.addSubview(dragButton)
        dragButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.centerX.equalTo(contentView)
        }
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.equalTo(dragButton.snp_bottomMargin).offset(16)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
        
        cardView.heightAnchor.constraint(equalToConstant: factTextView.bounds.height).isActive = true
        
        cardView.addSubview(factTextView)
        factTextView.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(10)
            make.left.equalTo(cardView).offset(10)
            make.right.equalTo(cardView).offset(-10)
        }
        
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-35)
        }
        
        contentView.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(shareButton.snp_topMargin).offset(-20)
        }
        
    }
}

