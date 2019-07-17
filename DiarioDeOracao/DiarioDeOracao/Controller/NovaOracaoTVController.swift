//
//  NovaOracaoTVController.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 16/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class NovaOracaoTVController: UITableViewController {

    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var urgenciaSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var notasTextField: UITextField!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var dataDatePicker: UIDatePicker!

    let formatoData = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatoData.dateStyle = DateFormatter.Style.short
        formatoData.locale = Locale(identifier: "pt_BR")
        
        let data = formatoData.string(from: Calendario.shared.retornaDataAtual())
        dataLabel.text = data
    }

    @IBAction func valorPickerAlterado(_ sender: Any) {
        let data = formatoData.string(from: dataDatePicker.date)
        dataLabel.text = data
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
