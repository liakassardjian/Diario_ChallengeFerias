//
//  TutorialPVController.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 19/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class TutorialPVController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    

    lazy var ordemViewControllers: [UIViewController] = {
        return [self.novaVC(viewController: "tela1"),
                self.novaVC(viewController: "tela2"),
                self.novaVC(viewController: "tela3")]
    }()
    
    var indexAtual = 0
    var tutorialViewController: TutorialVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        if let primeiraViewController = ordemViewControllers.first {
            setViewControllers([primeiraViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.delegate = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let indexViewController = ordemViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let indexAnterior = indexViewController - 1
        
        return self.conteudoViewControler(at: indexAnterior)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let indexViewController = ordemViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let indexPosterior = indexViewController + 1
        
        return self.conteudoViewControler(at: indexPosterior)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vC = pageViewController.viewControllers {
            let paginaAtualViewController = vC[0]
            if let index = ordemViewControllers.firstIndex(of: paginaAtualViewController) {
                self.indexAtual = index
            }
        }
        
        if let tVC = tutorialViewController {
            tVC.atualizaInterface()
        }
    }
    
    func novaVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func conteudoViewControler(at index: Int) -> UIViewController? {
        if index < 0 || index >= ordemViewControllers.count {
            return nil
        }
        
        return ordemViewControllers[index]
    }
    
    func avancarPagina() {
        indexAtual += 1
        if let proximaViewController = self.conteudoViewControler(at: indexAtual) {
            setViewControllers([proximaViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
