//
//  SecondViewController.swift
//  BaeminPrac
//
//  Created by 최동호 on 2018. 2. 5..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {
    
    var selectedCourse: Course?
    
    var barStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    @IBOutlet weak var buttonViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerBackgroundView: UIView!
    
    @IBOutlet weak var blackBackButton: UIButton!
    @IBOutlet weak var whiteBackButton: UIButton!
    @IBAction func blackBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var topImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        topImageView.image = UIImage(named: (selectedCourse?.imageName)!)
//        titleLabel.text = selectedCourse?.title
//        
        headerBackgroundView.alpha = 0.0
        blackBackButton.alpha = 0.0
        whiteBackButton.alpha = 1.0
        titleLabel.alpha = 0.0
        
        listTableView.contentInset = .init(top: 200, left: 0, bottom: 0, right: 0)
        listTableView.scrollIndicatorInsets = listTableView.contentInset
        
//        이전버전 
        listTableView.estimatedRowHeight = 100
        listTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    var floatingMenuBase: CGFloat? = 0.0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if floatingMenuBase == 0.0 {
            let indexPath = IndexPath(row: 1, section: 0)
            if let cell = listTableView.cellForRow(at: indexPath) {
                let frame = view.convert(cell.frame, to: view)
                floatingMenuBase = frame.origin.y + listTableView.contentInset.top
                buttonViewTopConstraint.constant = floatingMenuBase!
            }
        }
    }
    
    
    
    
}

extension SecondViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "infoCell")!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummy")
        cell?.contentView.backgroundColor = indexPath.row == 1 ? UIColor.blue : UIColor.red
//        cell?.textLabel?.text = "Dummy!!!"
        return cell!
        
        
    }
    
}



extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            return 60
        default:
            return 3000
        }
    }
    

}

extension SecondViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        print(y)
        
        let diff = y + 200
//            print(diff)

        if y < -200 {
//            print("\(abs(diff))")
            self.imageViewHeightConstraint.constant = 300 + abs(diff)
        } else {
            self.imageViewHeightConstraint.constant = 300
        }
        buttonViewTopConstraint.constant = floatingMenuBase! - diff

        if y > 0 {
            barStyle = .default
            UIView.animate(withDuration: 0.2, delay: TimeInterval(0), options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.headerBackgroundView.alpha = 1.0
                self.blackBackButton.alpha = 1.0
                self.whiteBackButton.alpha = 0.0
                self.titleLabel.alpha = 1.0

            }, completion: nil)
           
        } else {
            barStyle = .lightContent
            UIView.animate(withDuration: 0.2, delay: TimeInterval(0), options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.headerBackgroundView.alpha = 0.0
                self.blackBackButton.alpha = 0.0
                self.whiteBackButton.alpha = 1.0
                self.titleLabel.alpha = 0.0
//                self.imageViewHeightConstraint.constant = -y + 200
                
                
            }, completion: nil)
        }
       setNeedsStatusBarAppearanceUpdate()
    }
}
