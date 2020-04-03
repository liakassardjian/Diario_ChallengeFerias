//
//  NovaLembrancaVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 01/08/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

class NovaLembrancaVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var corpoTextView: UITextView!
    
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    @IBOutlet weak var excluirButton: UIBarButtonItem!
        
    var diario: DiarioVC?
    var lembrancaCVC: LembrancasCVController?
    
    var textFieldDelegate: TextFieldDelegate?
    
    let modeloLembranca = ["Título da sua lembrança", "Descreva aqui o acontecimento"]
    var conteudo: [String] = []
    
    var novaLembranca: Lembranca?
    var modoEdicao: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldDelegate = TextFieldDelegate(modelo: modeloLembranca)
        tituloTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tituloTextField.delegate = textFieldDelegate
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
        if !modoEdicao {
            novaLembranca = CoreDataManager.shared.createLembranca()
            
            if let diario = diario {
                diario.lembrancaAdicionada = true
            }
        }
        novaLembranca?.titulo = textFieldDelegate?.leTextField(textField: tituloTextField)
        novaLembranca?.corpo = leTextView(textView: corpoTextView)
        novaLembranca?.data = CoreDataManager.shared.dia
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        CoreDataManager.shared.fetchLembrancas()
        
        return true
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
        if
            let titulo = tituloTextField.text,
            let corpo = tituloTextField.text,
            let enabled = textFieldDelegate?.validaTexto(titulo: titulo, corpo: corpo) {
                salvarButton.isEnabled = enabled
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
