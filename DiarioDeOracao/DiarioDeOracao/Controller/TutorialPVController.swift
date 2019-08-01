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
                self.novaVC(viewController: "tela3"),
                self.novaVC(viewController: "tela4"),
                self.novaVC(viewController: "tela5"),
                self.novaVC(viewController: "tela6")]
    }()
    
    lazy var ordemSegundaTela: [UIViewController] = {
        return [self.novaVC(viewController: "tela2"),
                self.novaVC(viewController: "tela3"),
                self.novaVC(viewController: "tela4"),
                self.novaVC(viewController: "tela5"),
                self.novaVC(viewController: "tela6")]
    }()
    
    var indexAtual = 0
    var tutorialViewController: TutorialVC?
    var primeiroTutorial:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if primeiroTutorial {
            if let primeiraViewController = ordemViewControllers.first {
                setViewControllers([primeiraViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
        } else {
            if let primeiraViewController = ordemSegundaTela.first {
                setViewControllers([primeiraViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
        }
        
        self.delegate = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index:Int
        
        if primeiroTutorial {
            guard let indexViewController = ordemViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            index = indexViewController
        } else {
            guard let indexViewController = ordemSegundaTela.firstIndex(of: viewController) else {
                return nil
            }
            index = indexViewController
        }
        
        let indexAnterior = index - 1
        
        return self.conteudoViewControler(at: indexAnterior)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index:Int
        
        if primeiroTutorial {
            guard let indexViewController = ordemViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            index = indexViewController
        } else {
            guard let indexViewController = ordemSegundaTela.firstIndex(of: viewController) else {
                return nil
            }
            index = indexViewController
        }
        
        let indexPosterior = index + 1
        
        return self.conteudoViewControler(at: indexPosterior)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vC = pageViewController.viewControllers {
            let paginaAtualViewController = vC[0]
            
            if primeiroTutorial {
                if let index = ordemViewControllers.firstIndex(of: paginaAtualViewController) {
                    self.indexAtual = index
                }
            } else {
                if let index = ordemSegundaTela.firstIndex(of: paginaAtualViewController) {
                    self.indexAtual = index
                }
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
        if primeiroTutorial {
            if index < 0 || index >= ordemViewControllers.count {
                return nil
            }
            
            return ordemViewControllers[index]
        } else {
            if index < 0 || index >= ordemSegundaTela.count {
                return nil
            }
            
            return ordemSegundaTela[index]
        }
        
    }
    
    func avancarPagina() {
        indexAtual += 1
        if let proximaViewController = self.conteudoViewControler(at: indexAtual) {
            setViewControllers([proximaViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}
