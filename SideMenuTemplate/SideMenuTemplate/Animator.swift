//
//  Animator.swift
//  SideMenuTemplate
//
//  Created by Anatoliy on 13.02.2022.
//

import UIKit

//MARK: - анимация открытия меню
class PushAnimator: NSObject,  UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return } //с которого переходим
        guard let destination = transitionContext.viewController(forKey: .to) else { return } //на который переходим
        
        //добавляем на контекст вью, которую будем презентовать и задаеём её размер
        transitionContext.containerView.addSubview(destination.view)
        
        destination.view.frame = CGRect(x: source.view.safeAreaLayoutGuide.layoutFrame.origin.x,
                                        y: source.view.safeAreaLayoutGuide.layoutFrame.origin.y,
                                        width: source.view.frame.width * 0.4,
                                        height: source.view.safeAreaLayoutGuide.layoutFrame.height)
        
        destination.view.roundCorners([.topRight, .bottomRight], radius: destination.view.frame.width * 0.1)
        
        destination.view.transform = CGAffineTransform(translationX: source.view.frame.width * -0.4, y: 0)

        //делаем саму анимацию
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                let transform = CGAffineTransform(translationX: source.view.frame.origin.x, y: 0)
                destination.view.transform = transform
            }
            
        }) { result in
            if result && !transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(true)
            } else {
                transitionContext.completeTransition(false)
            }
        }
    }
}

//MARK: - закрытие меню
class PopAnimator: NSObject,  UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return } //с которого переходим
        guard let destination = transitionContext.viewController(forKey: .to) else { return } //на который переходим

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                let transform = CGAffineTransform(translationX: destination.view.frame.width * -0.4, y: 0)
                source.view.transform = transform
            }
            
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
                transitionContext.completeTransition(true)
            } else {
                transitionContext.completeTransition(false)
            }
        }
    }
}

//MARK: - Interactive Transition
class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    weak var viewController: UIViewController? {
        didSet {
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: gesture.view)

        switch gesture.state {
        case .began:
            hasStarted = true
            viewController?.dismiss(animated: true, completion: nil)
            
        case .changed:
            
            //let relativeTranslation = -(translation.x / (gesture.view?.bounds.width ?? 1))
            let relativeTranslation = -(translation.x / (gesture.view?.bounds.width ?? 1))
            
            let progress = max(0, min(1, relativeTranslation))
            print("трансляция (отклонение пальца) = \(progress)")
            if progress > 0 && progress > 0.33 {
                shouldFinish = true
                update(progress)
            } else if  progress > 0 && progress < 0.33 {
                shouldFinish = false
                update(progress)
            }

        case .ended:
            hasStarted = false
            if shouldFinish == true {
                finish()
                print("завершаю")
                shouldFinish = false
            } else {
                cancel()
                print("отменяю")
            }
            
        case .cancelled:
            hasStarted = false
            cancel()
        default:
            return
            
        }
    }
}
