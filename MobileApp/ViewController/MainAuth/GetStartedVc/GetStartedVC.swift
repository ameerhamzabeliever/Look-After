//
//  GetStartedVC.swift
//  MobileApp
//
//  Created by TecSpine on 16/09/2021.
//

import UIKit

class GetStartedVC: BaseVC{

    @IBOutlet weak var getStarted: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func navigateToSigninScreen(_ sender: Any) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.signIn, StoryBoard: Storyboard.Ids.main)
    }
    
    func layoutUI(){
        getStarted.layer.cornerRadius = 8
    }
}
