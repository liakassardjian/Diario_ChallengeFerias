//
//  NovaNotaTVController.swift
//  
//
//  Created by Lia Kassardjian on 16/07/19.
//

import UIKit
import CoreData

class NovaNotaTVController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var corpoTextView: UITextView!
    
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    let modeloNota = ["Nova nota","Escreva aqui sua nota"]
    var conteudo:[String] = []
    
    var context:NSManagedObjectContext?
    var novaNota:Nota?
    var modoEdicao:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        tituloTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tituloTextField.delegate = self
        corpoTextView.delegate = self
        
        salvarButton.isEnabled = false
        
        if modoEdicao {
            self.navigationItem.title = "Editar nota"
        } else {
            self.navigationItem.title = "Nova nota"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if modoEdicao {
            tituloTextField.text = conteudo[0]
            corpoTextView.text = conteudo[1]
        } else {
            tituloTextField.text = modeloNota[0]
            corpoTextView.text = modeloNota[1]
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
                novaNota = NSEntityDescription.insertNewObject(forEntityName: "Nota", into: context) as! Nota
            }
            novaNota?.titulo = leTextField(textField: tituloTextField)
            novaNota?.corpo = leTextView(textView: corpoTextView)
            
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
    
    func validaTexto(titulo: String, corpo: String) {
        if titulo != "" && corpo != "" && titulo != modeloNota[0] && corpo != modeloNota[1] {
            salvarButton.isEnabled = true
        } else {
            salvarButton.isEnabled = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == modeloNota[0] {
            textField.text = ""
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == modeloNota[1] {
            textView.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = modeloNota[0]
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = modeloNota[1]
        }
    }

}
