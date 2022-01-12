//
//  ViewController.swift
//  SynonymGen
//
//  Created by 梁程 on 2021/12/27.
//


import UIKit
class ViewController: UITabBarController {
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        let profileVC = SettingsViewController()
        let factsListVC = FactsListViewController()
        
        homeVC.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(systemName: "house.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "tabBar")!), tag: 0)
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(K.brandYellow)
        
        factsListVC.tabBarItem = UITabBarItem.init(title: "Facts", image: UIImage(systemName: "heart.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "tabBar")!), tag: 0)
        factsListVC.tabBarItem.selectedImage = UIImage(systemName: "heart.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(K.brandYellow)
        
        profileVC.tabBarItem = UITabBarItem.init(title: "Settings", image: UIImage(systemName: "gearshape.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "tabBar")!), tag: 0)
        profileVC.tabBarItem.selectedImage = UIImage(systemName: "gearshape.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(K.brandYellow)
        
        tabBar.unselectedItemTintColor = .black
        
        tabBar.clipsToBounds = true
        tabBar.isTranslucent = false
        let selectedColor = K.brandYellow
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "text")!], for: .normal)
        let controllerArray = [homeVC, factsListVC,profileVC]
        self.viewControllers = controllerArray.map{(UINavigationController.init(rootViewController: $0))}
    }
}

