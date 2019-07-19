//
//  TutorialVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 19/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pularButton: UIButton!
    @IBOutlet weak var proximoButton: UIButton! {
        didSet {
            self.proximoButton.layer.cornerRadius = 25
            self.proximoButton.layer.masksToBounds = true
        }
    }
    
    var pageViewController: TutorialPVController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pularButton.isHidden = true
    }
    
    
    @IBAction func pularTutorial(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func avancarPagina(_ sender: Any) {
        if let index = pageViewController?.indexAtual {
            switch index {
            case 0...1:
                pageViewController?.avancarPagina()
            case 2:
                dismiss(animated: true, completion: nil)
                
            default:
                break
            }
        }
        self.atualizaInterface()
    }
    
    func atualizaInterface() {
        if let index = pageViewController?.indexAtual {
            switch index {
            case 0:
                proximoButton.setTitle("Próximo", for: .normal)
                pularButton.isHidden = true
                
            case 1:
                proximoButton.setTitle("Próximo", for: .normal)
                pularButton.isHidden = false
                
            case 2:
                proximoButton.setTitle("Começar", for: .normal)
                pularButton.isHidden = true
                
            default:
                break
            }
            pageControl.currentPage = index
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pVC = destination as? TutorialPVController {
            pageViewController = pVC
            pVC.tutorialViewController = self
        }
    }


}
