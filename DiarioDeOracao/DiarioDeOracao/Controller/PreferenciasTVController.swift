//
//  PreferenciasTVController.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 01/08/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import UserNotifications

class PreferenciasTVController: UITableViewController {

    var horarioAlterado: Bool = false
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var notificacaoSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        let hora = UserDefaults().integer(forKey: "hora")
        let minuto = UserDefaults().integer(forKey: "minuto")
        
        datePicker.setDate(Calendario.shared.retornaDataHoraMinuto(hora: hora, minuto: minuto), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 1 {
            return 44
        } else {
            if notificacaoSwitch.isOn {
                return 209
            }
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
            if let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "tutorialVC") as? TutorialVC {
                present(tutorialViewController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func swicthAlterado(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func concluir(_ sender: Any) {
        if notificacaoSwitch.isOn && horarioAlterado {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            let horario = Calendario.shared.retornaDateComponents(date: datePicker.date)
            (UIApplication.shared.delegate as? AppDelegate)?.enviaNotificacao(data: horario)
        } else if !notificacaoSwitch.isOn {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickerAlterado(_ sender: Any) {
        horarioAlterado = true
    }
    
}
