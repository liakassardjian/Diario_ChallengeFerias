//
//  NovaOracaoTVController.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 16/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

class NovaOracaoTVController: UITableViewController {
    
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var urgenciaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataDatePicker: UIDatePicker!
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    let formatoData = DateFormatter()
    
    var textFieldDelegate: TextFieldDelegate?
    
    var novoPedido: Pedido?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatoData.dateStyle = DateFormatter.Style.short
        formatoData.locale = Locale(identifier: "pt_BR")
        
        let data = formatoData.string(from: Calendario.shared.retornaDataAtual())
        dataLabel.text = data
        
        textFieldDelegate = TextFieldDelegate()
        tituloTextField.delegate = textFieldDelegate
        tituloTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        salvarButton.isEnabled = false
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func valorPickerAlterado(_ sender: Any) {
        let data = formatoData.string(from: dataDatePicker.date)
        dataLabel.text = data
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let nome = textFieldDelegate?.leTextField(textField: tituloTextField) else { return false }
        let urgencia = urgenciaSegmentedControl.selectedSegmentIndex
        let data = dataDatePicker.date
        
        novoPedido = CoreDataManager.shared.createPedido(nome: nome, urgencia: urgencia, data: data)
        return true
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        if let texto = tituloTextField.text {
            guard let enabled = textFieldDelegate?.validaTexto(texto: texto) else { return }
            salvarButton.isEnabled = enabled
        } else {
            salvarButton.isEnabled = false
        }
    }
}
