//
//  TutorialVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 19/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import UserNotifications

class TutorialVC: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pularButton: UIButton!
    @IBOutlet weak var proximoButton: UIButton! {
        didSet {
            self.proximoButton.layer.cornerRadius = 22
            self.proximoButton.layer.masksToBounds = true
        }
    }
    
    var pageViewController: TutorialPVController?
    var horario:DateComponents?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pularButton.isHidden = true

    }
    
    @IBAction func pularTutorial(_ sender: Any) {
        dismiss(animated: true, completion: {
            if let h = self.horario {
                (UIApplication.shared.delegate as! AppDelegate).enviaNotificacao(data: h)
            }
        })
    }
    
    @IBAction func avancarPagina(_ sender: Any) {
        if let index = pageViewController?.indexAtual {
            switch index {
            case 0:
                let tela1:TutorialTela1VC = pageViewController?.ordemViewControllers[0] as! TutorialTela1VC
                horario = Calendario.shared.retornaDateComponents(date: tela1.datePicker.date)
                pageViewController?.avancarPagina()
            case 1...4:
                pageViewController?.avancarPagina()
            case 5:
                dismiss(animated: true, completion: {
                    if let h = self.horario {
                        (UIApplication.shared.delegate as! AppDelegate).enviaNotificacao(data: h)
                    }
                })
                
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
                
            case 1...4:
                proximoButton.setTitle("Próximo", for: .normal)
                pularButton.isHidden = false
                
            case 5:
                proximoButton.setTitle("Começar", for: .normal)
                pularButton.isHidden = true
                
            default:
                break
            }
            pageControl.currentPage = index
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destino = segue.destination
        if let pVC = destino as? TutorialPVController {
            pageViewController = pVC
            pVC.tutorialViewController = self
        }
    }

    
}
