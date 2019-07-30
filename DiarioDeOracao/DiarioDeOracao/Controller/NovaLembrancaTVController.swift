//
//  NovaLembrancaTVController.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 18/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

class NovaLembrancaTVController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var corpoTextView: UITextView!
    
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    var context:NSManagedObjectContext?
    
    var data:Dia?
    
    let modeloLembranca = ["Título da sua lembrança","Descreva aqui o acontecimento"]
    var conteudo:[String] = []
    
    var novaLembranca:Lembranca?
    var modoEdicao:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        tituloTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tituloTextField.delegate = self
        corpoTextView.delegate = self
        
        salvarButton.isEnabled = false
        
        if modoEdicao {
            self.navigationItem.title = "Editar lembrança"
        } else {
            self.navigationItem.title = "Oração respondida"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if modoEdicao {
            tituloTextField.text = conteudo[0]
            corpoTextView.text = conteudo[1]
        } else {
            tituloTextField.text = modeloLembranca[0]
            corpoTextView.text = modeloLembranca[1]
            conteudo = ["",""]
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let context = context {
            if !modoEdicao {
                novaLembranca = NSEntityDescription.insertNewObject(forEntityName: "Lembranca", into: context) as! Lembranca
            }
            novaLembranca?.titulo = leTextField(textField: tituloTextField)
            novaLembranca?.corpo = leTextView(textView: corpoTextView)
            
            if let data = data {
                novaLembranca?.data = data
            }
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            return true
        }
        return false
    }

    func leTextField(textField: UITextField) -> String {
        var texto:String = ""
        if textField.text != nil,
            textField.text!.count > 0 {
            texto = textField.text!
        }
        return texto
    }
    
    func leTextView(textView: UITextView) -> String {
        var texto:String = ""
        if textView.text != nil,
            textView.text!.count > 0 {
            texto = textView.text!
        }
        return texto
    }

    @IBAction func textFieldDidChange(_ sender: Any) {
        if let titulo = tituloTextField.text {
            if let corpo = tituloTextField.text {
                validaTexto(titulo: titulo, corpo: corpo)
            }
        } else {
            salvarButton.isEnabled = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let corpo = corpoTextView.text {
            if let titulo = tituloTextField.text {
                validaTexto(titulo: titulo, corpo: corpo)
            }
        } else {
            salvarButton.isEnabled = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == modeloLembranca[0] {
            textField.text = ""
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == modeloLembranca[1] {
            textView.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = modeloLembranca[0]
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = modeloLembranca[1]
        }
    }
    
    func validaTexto(titulo: String, corpo: String) {
        if titulo != "" && corpo != "" && titulo != modeloLembranca[0] && corpo != modeloLembranca[1] {
            salvarButton.isEnabled = true
        } else {
            salvarButton.isEnabled = false
        }
    }
}
