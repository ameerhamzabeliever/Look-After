//
//  GuidePageVC.swift
//  MobileApp
//
//  Created by TecSpine on 9/21/21.
//


import UIKit

class GuidePageVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView  : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var scrollView : UIScrollView!
    
    // MARK: - Class Properties
    var model: GuidePageModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.size.height)
      
    }
}

/* MARK:- Extensions */
extension GuidePageVC{
    func setupGUI() {
        imageView.image = model.imageName
        titleLabel.text = model.text
        bottomLabel.text = model.bottomlabel
      }
}
