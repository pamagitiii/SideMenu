//
//  ViewController.swift
//  SideMenuTemplate
//
//  Created by Anatoliy on 13.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let interactiveTransition = InteractiveTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openSideMenu(_ sender: Any) {
        let menuVC = MenuViewController()
        menuVC.transitioningDelegate = self
        menuVC.modalPresentationStyle = .custom
        interactiveTransition.viewController = menuVC
        present(menuVC, animated: true, completion: nil)
    }
    
    
    @IBAction func presentVC(_ sender: Any) {
        let greenVC = GreenViewController()
        present(greenVC, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimator()
    }
 
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}


