//
//  NovaNotaTVController.swift
//  
//
//  Created by Lia Kassardjian on 16/07/19.
//

import UIKit

class NovaNotaTVController: UITableViewController {

    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var corpoTextView: UITextView!
    
    let modeloNota = ["Nova nota","Escreva aqui sua nota"]
    var nota:[String] = ["Nova nota","Escreva aqui sua nota"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        tituloTextField.text = nota[0]
        corpoTextView.text = nota[1]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

}
