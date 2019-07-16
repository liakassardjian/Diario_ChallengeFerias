//
//  DiarioVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 15/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class DiarioVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var diaLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let titulos = ["Leitura bíblica diária","Lista de oração diária","Nota pessoal"]
    let textos = ["3/3 concluídos","4/5 concluídos","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 126
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notas") as! NotasTVCell
        
        cell.tituloLabel.text = titulos[indexPath.row]
        cell.corpoLabel.text = textos[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id:String
        if indexPath.row == 0 || indexPath.row == 1 {
            id = "cardFixoSegue"
        } else {
            id = "editarNotaSegue"
        }
        performSegue(withIdentifier: id, sender: self)
    }

    @IBAction func voltarDia(_ sender: Any) {
        Calendario.shared.decrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
    }
    
    @IBAction func avancarDia(_ sender: Any) {
        Calendario.shared.incrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
    }
    
    @IBAction func salvarNota(_ sender: UIStoryboardSegue){
        if sender.source is NovaNotaTVController {
            if let senderAdd = sender.source as? NovaNotaTVController {
                // adiciona nota
            }
        }
    }
}
