//
//  ViewController.swift
//  BaeminPrac
//
//  Created by 최동호 on 2018. 2. 1..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit

struct Course {
    let title: String
    let imageName: String
    let startDate: Date
    let endDate: Date
    let tags: [String]
    let location: String
}

class ViewController: UIViewController {
    lazy var df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "M월 d일(E)"
        return df
    }()
    
    
    var courseList = [
        Course(title: "Swift4를 활용한 iOS 앱 개발 CAMP", imageName: "course0", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A"),
        Course(title: "나만의 iOS 앱 개발 입문 CAMP", imageName: "course1", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A"),
        Course(title: "Unity 5 게임 제작 CAMP", imageName: "course2", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A"),
        Course(title: "JavaScript 정복 프로젝트 CAMP", imageName: "course3", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A"),
        Course(title: "Node.js로 구현하는 쇼핑몰 프로젝트 CAMP", imageName: "course4", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A")
    ]
    
    @IBOutlet weak var center1: NSLayoutConstraint!
    @IBOutlet weak var center2: NSLayoutConstraint!
    @IBOutlet weak var center3: NSLayoutConstraint!
    @IBOutlet weak var center4: NSLayoutConstraint!
    @IBOutlet weak var center5: NSLayoutConstraint!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var courseCollectionView: UICollectionView!
    
    @IBOutlet weak var moverWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! SecondViewController
        let selectedIndexPath = self.courseCollectionView.indexPathsForSelectedItems?.first!
        let course = courseList[(selectedIndexPath?.row)!]
        destVC.selectedCourse = course
    }
    
    @IBAction func buttonMoveAction(_ sender: UIButton) {
        center1.isActive = sender.tag == 100
        center2.isActive = sender.tag == 200
        center3.isActive = sender.tag == 300
        center4.isActive = sender.tag == 400
        center5.isActive = sender.tag == 500
        
        let buttonTextInfo = [NSAttributedStringKey.font: sender.titleLabel!.font!]
        
        
        var buttonTextWidth: CGFloat = 100
        if let text = sender.title(for: .normal) {
            buttonTextWidth = (text as NSString).size(withAttributes: buttonTextInfo).width
        }
        
//        let randomIndexPath: IndexPath = IndexPath(item: Int(arc4random_uniform(UInt32(courseList.count - 1))), section: 0)
//        self.courseCollectionView.beginInteractiveMovementForItem(at: randomIndexPath)
//        self.courseCollectionView.endInteractiveMovement()
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.moverWidthConstraint.constant = buttonTextWidth
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        for _ in 0...10 {
            let a = arc4random_uniform(UInt32(courseList.count))
            let b = arc4random_uniform(UInt32(courseList.count))
            courseList.swapAt(Int(a), Int(b))
        }
        courseCollectionView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        buttonMoveAction(firstButton)
        for _ in 0...10 {
            let a = arc4random_uniform(UInt32(courseList.count))
            let b = arc4random_uniform(UInt32(courseList.count))
            courseList.swapAt(Int(a), Int(b))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let targetIndexPath: IndexPath = IndexPath(item: 5000, section: 0)
//        self.bannerCollectionView.selectItem(at: targetIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
//        
        self.bannerCollectionView.reloadItems(at: [targetIndexPath])
        
//        self.bannerCollectionView.scrollToItem(at: targetIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        resumeTimer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.suspend()
    }
  
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.bannerCollectionView.collectionViewLayout.invalidateLayout()
        let currentIndexPath = self.bannerCollectionView.indexPathsForVisibleItems.first!
        DispatchQueue.main.async {
            self.bannerCollectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    var timer: DispatchSourceTimer?
    
    func resumeTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timer?.schedule(deadline: .now() + 5, repeating: 5.0)
            timer?.setEventHandler(handler: {
                if var currentIndex: IndexPath = self.bannerCollectionView.indexPathsForVisibleItems.first {
                    currentIndex.item += 1
                    self.bannerCollectionView.selectItem(at: currentIndex, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
                }
            })
        }
        timer?.resume()
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
    


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.bannerCollectionView {
            return 10000
        }
        
        return courseList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCollectionViewCell
            
            cell.bannerImageView.image = UIImage(named: "banner\(indexPath.row % 5)")
            
        
            return cell
            
        }
        
        let targetCourse = self.courseList[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CourseCollectionViewCell
        
        cell.courseImageView.image = UIImage(named: "\(targetCourse.imageName)")
        cell.titleLabel.text = "\(targetCourse.title)"
        
        cell.dateLabel.text = "\(self.df.string(from: targetCourse.startDate))~\(self.df.string(from: targetCourse.endDate))"
        cell.tagLabel.text = "# " + targetCourse.tags.joined(separator: " #")
        cell.locationLabel.text = targetCourse.location
        
        return cell
        
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.bannerCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        let width = (collectionView.bounds.width - 30) / 2
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
}

