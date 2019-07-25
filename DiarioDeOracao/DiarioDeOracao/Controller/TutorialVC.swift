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
    var horario:Double = 0
    
    let tituloNotificacao = "Hora da sua devocional"
    let descricaoNotificacao = "Lembre-se de reservar um tempo para meditar na Bíblia e orar"
    
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
            case 0:
                let tela1:TutorialTela1VC = pageViewController?.ordemViewControllers[0] as! TutorialTela1VC
                horario = tela1.datePicker.date.timeIntervalSinceNow
                
                enviaNotificacao(tempo: horario)
                
                pageViewController?.avancarPagina()
            case 1...3:
                pageViewController?.avancarPagina()
            case 4:
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
                
            case 1...3:
                proximoButton.setTitle("Próximo", for: .normal)
                pularButton.isHidden = false
                
            case 4:
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
    
    func configuraAcoesNotificacao() -> UNNotificationCategory {
        let adiar = UNNotificationAction(identifier: "ADIAR",
                                         title: "Lembre-me em 5 minutos",
                                         options: UNNotificationActionOptions(rawValue: 0))
        
        let concluir = UNNotificationAction(identifier: "CONCLUIR",
                                            title: "Ver agora",
                                            options: [.foreground])
        
        let categoriaLembrete = UNNotificationCategory(identifier: "DIARIO_NOTIFICACOES",
                                                       actions: [adiar, concluir],
                                                       intentIdentifiers: [],
                                                       options: .customDismissAction)
        
        return categoriaLembrete
    }
    
    
    func enviaNotificacao(tempo: Double) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let categoria = self.configuraAcoesNotificacao()
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: self.tituloNotificacao, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: self.descricaoNotificacao, arguments: nil)
                content.sound = UNNotificationSound.default
                content.badge = 1 
                content.categoryIdentifier = "DIARIO_NOTIFICACOES"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: tempo, repeats: false)
                
                let request = UNNotificationRequest(identifier: "lembrete", content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                center.setNotificationCategories([categoria])
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                print("Impossível mandar notificação - permissão negada")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
        if content.categoryIdentifier == "DIARIO_NOTIFICACOES" {
            switch response.actionIdentifier {
            case "ADIAR":
                chamaNotificacao()
                break
                
            case "CONCLUIR":
                break
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func chamaNotificacao() {
        let tempo:Double = 300
        
        enviaNotificacao(tempo: tempo)
    }

}
