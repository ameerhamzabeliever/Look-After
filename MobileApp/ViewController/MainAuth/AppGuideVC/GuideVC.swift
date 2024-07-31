//
//  GuideVC.swift
//  MobileApp
//
//  Created by TecSpine on 9/21/21.
//

import Foundation
import UIKit

struct GuidePageModel {
    var text        :String = ""
    var imageName   :UIImage!
    var bottomlabel :String = ""
}

class GuideVC: BaseVC {

    @IBOutlet weak var paginationIndicator: UIPageControl!
    
    var dataModel: [GuidePageModel] = [GuidePageModel(text: "Welcome To Village Maker", imageName: UIImage(named: "1st"), bottomlabel: "It Takes A Village"),
           GuidePageModel(text: "Ask For Aid When In Need", imageName: UIImage(named: "A whole year-pana 1"), bottomlabel: "It Takes A Village"),
           GuidePageModel(text: "Help Those Who Are In Need", imageName: UIImage(named: "My password-amico (2) 1-2"), bottomlabel: "It Takes A Village")]
    
    
    // MARK: - IBOutlets
      @IBOutlet weak var contentView: UIView!
//
      // MARK: - Class Properties
      var viewControllers = [UIViewController]()
      var pageController: UIPageViewController?
      var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        paginationIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pageController?.view.frame = self.contentView.frame
//        pageController?.view.setNeedsLayout()
//        pageController?.view.layoutIfNeeded()
        viewControllers.forEach { (vc) in
//          vc.view.frame = self.contentView.frame
//          vc.view.setNeedsLayout()
//          vc.view.layoutIfNeeded()
        }
        
    }
    
}


    // MARK: - Class Methods
extension GuideVC {
    
  fileprivate func initialSetup() {
    configurePageViewController()
  }
    
  func loadTurorialDataVC(model: GuidePageModel)-> GuidePageVC {
    let vc: GuidePageVC = getViewController(sbName: Storyboard.Ids.main, vcName: "GuidePageVC")
    vc.model = model
    return vc
  }
    
    fileprivate func configurePageViewController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        viewControllers = dataModel.map({loadTurorialDataVC(model: $0)})
        if let firstVC = viewControllers.first {
          pageController?.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            paginationIndicator.numberOfPages = viewControllers.count
          addChildViewControllerWithView(pageController!)
          
        }
    }
    
  func addChildViewControllerWithView(_ childViewController: UIViewController, toView view: UIView? = nil) {
    let view: UIView = view ?? self.view
    childViewController.removeFromParent()
    childViewController.willMove(toParent: self)
    addChild(childViewController)
    view.addSubview(childViewController.view)
    childViewController.didMove(toParent: self)
//    view.setNeedsLayout()
//    view.layoutIfNeeded()
  }
  
}
    // MARK: - IBActions
extension GuideVC {
    @IBAction func nextButtonPressed(_ sender: UIButton) {
      if paginationIndicator.currentPage == 2 {
        UserDefaults.standard.set(true, forKey: "isVisited")
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.getStarted, StoryBoard: Storyboard.Ids.main)
      }
      else{
          guard let currrentPage = self.pageController?.viewControllers?.first else { return }
          guard let vc = self.pageViewController(self.pageController!, viewControllerAfter: currrentPage) else { return }
          self.pageController?.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
          paginationIndicator.currentPage = viewControllers.firstIndex(of: vc)!
      }
      
    
    
    }
  @IBAction func skipButtonPressed(_ sender: UIButton) {
    UserDefaults.standard.set(true, forKey: "isVisited")
    self.PushViewWithStoryBoard(name: ViewControllerName.Names.getStarted, StoryBoard: Storyboard.Ids.main)

  }

}
    // MARK: PageController Delegates
extension GuideVC: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if let lastPushedVC = pageViewController.viewControllers?.last {
        paginationIndicator.currentPage = viewControllers.firstIndex(of: lastPushedVC)!
    }
  }
}
    // MARK: - PageController DataSource
extension GuideVC: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentIndex: Int = viewControllers.firstIndex(of: viewController) else {
      return nil
    }
    let previousIndex = currentIndex - 1
    if currentIndex == 0 {
      return nil
    }
    return viewControllers[previousIndex]
  }
    
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
      return nil
    }
    let nextIndex = currentIndex + 1
    if nextIndex >= dataModel.count {
      return nil
    }
    return viewControllers[nextIndex]
  }
    
    func getViewController<T: UIViewController>(sbName: String, vcName: String) -> T {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: vcName) as! T
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        return vc
      }
}


extension UIScrollView {
  func updateContentView() {
    contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
  }
}
