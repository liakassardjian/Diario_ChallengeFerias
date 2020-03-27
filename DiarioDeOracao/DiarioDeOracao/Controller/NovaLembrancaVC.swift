//
//  NovaLembrancaVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 01/08/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

class NovaLembrancaVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var corpoTextView: UITextView!
    
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    @IBOutlet weak var excluirButton: UIBarButtonItem!
    
    var context: NSManagedObjectContext?
    
    var data: Dia?
    var diario: DiarioVC?
    var lembrancaCVC: LembrancasCVController?
    
    let modeloLembranca = ["Título da sua lembrança", "Descreva aqui o acontecimento"]
    var conteudo: [String] = []
    
    var novaLembranca: Lembranca?
    var modoEdicao: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        tituloTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tituloTextField.delegate = self
        corpoTextView.delegate = self
        salvarButton.isEnabled = false
        
        if modoEdicao {
            self.navigationItem.title = "Editar lembrança"
            self.excluirButton.isEnabled = true
        } else {
            self.navigationItem.title = "Oração respondida"
            self.excluirButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if modoEdicao {
            tituloTextField.text = conteudo[0]
            corpoTextView.text = conteudo[1]
        } else {
            tituloTextField.text = modeloLembranca[0]
            corpoTextView.text = modeloLembranca[1]
            conteudo = ["", ""]
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let context = context {
            if !modoEdicao {
                novaLembranca = NSEntityDescription.insertNewObject(forEntityName: "Lembranca", into: context) as? Lembranca
                
                if let diario = diario {
                    diario.lembrancaAdicionada = true
                }
            }
            novaLembranca?.titulo = leTextField(textField: tituloTextField)
            novaLembranca?.corpo = leTextView(textView: corpoTextView)
            
            if let data = data {
                novaLembranca?.data = data
            }
            
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

    @IBAction func excluirLembranca(_ sender: Any) {
        let alert = UIAlertController(title: "Excluir lembrança",
                                      message: "Tem certeza de que deseja excluir essa lembrança?",
                                      preferredStyle: .alert)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let exluir = UIAlertAction(title: "Excluir", style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            if let lem = self.lembrancaCVC {
                lem.lembrancaFoiDeletada = true
                lem.lembrancaDeletada = self.novaLembranca
            }
        })
        
        alert.addAction(cancelar)
        alert.addAction(exluir)
        present(alert, animated: true, completion: nil)
    }
}
