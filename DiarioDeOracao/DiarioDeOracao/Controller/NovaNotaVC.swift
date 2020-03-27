//
//  NovaNotaVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 01/08/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

class NovaNotaVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

   @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var corpoTextView: UITextView!
    
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    @IBOutlet weak var excluirButton: UIBarButtonItem!
    
    var diario: DiarioVC?
    
    let modeloNota = ["Nova nota", "Escreva aqui sua nota"]
    var conteudo = [String]()
    
    var context: NSManagedObjectContext?
    var novaNota: Nota?
    var modoEdicao: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        tituloTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tituloTextField.delegate = self
        corpoTextView.delegate = self
        
        salvarButton.isEnabled = false
        
        if modoEdicao {
            self.navigationItem.title = "Editar nota"
            excluirButton.isEnabled = true
        } else {
            self.navigationItem.title = "Nova nota"
            excluirButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if modoEdicao {
            tituloTextField.text = conteudo[0]
            corpoTextView.text = conteudo[1]
        } else {
            tituloTextField.text = modeloNota[0]
            corpoTextView.text = modeloNota[1]
            conteudo = ["", ""]
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let context = context {
            if !modoEdicao {
                novaNota = NSEntityDescription.insertNewObject(forEntityName: "Nota", into: context) as? Nota
            }
            novaNota?.titulo = leTextField(textField: tituloTextField)
            novaNota?.corpo = leTextView(textView: corpoTextView)
            
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            
            return true
        }
        return false
    }
    
    func leTextField(textField: UITextField) -> String {
        var texto: String = ""
        
        guard let entrada = textField.text else { return "" }
        if entrada.count > 0 {
            texto = entrada
        }
        return texto
    }
    
    func leTextView(textView: UITextView) -> String {
        var texto: String = ""
        
        guard let entrada = textView.text else { return "" }
        if entrada.count > 0 {
            texto = entrada
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

    @IBAction func excluirNota(_ sender: Any) {
        
        let alert = UIAlertController(title: "Excluir nota", message: "Tem certeza de que deseja excluir essa nota?", preferredStyle: .alert)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let exluir = UIAlertAction(title: "Excluir", style: .destructive, handler: { _ in
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                if let diario = self.diario {
                    diario.notaFoiDeletada = true
                    diario.notaDeletada = self.novaNota
                }
            })
        
        alert.addAction(cancelar)
        alert.addAction(exluir)
        present(alert, animated: true, completion: nil)
    }
    
}
