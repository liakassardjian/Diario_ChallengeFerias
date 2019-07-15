//
//  DiarioVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 15/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class DiarioVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

    @IBOutlet weak var diaLabel: UILabel!
    
    @IBOutlet weak var camposFixos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        diaLabel.text = Calendario.shared.retornaDiaAtual()
    }
    
    @IBAction func voltarDia(_ sender: Any) {
        Calendario.shared.decrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
    }
    
    @IBAction func avancarDia(_ sender: Any) {
        Calendario.shared.incrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
    }

}
