//
//  PresentationController.swift
//  SideMenuTemplate
//
//  Created by Anatoliy on 13.02.2022.
//

import UIKit

class PresentationController: UIPresentationController {
  
  let blurEffectView: UIVisualEffectView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      let blurEffect = UIBlurEffect(style: .extraLight)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
  }

  override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0.7
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
  }
  
  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
      })
  }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed == true {
            self.blurEffectView.removeFromSuperview()
        }
    }
  
  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
  }

  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      blurEffectView.frame = containerView!.bounds
  }

  @objc func dismissController(){
      self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}
