//
//  NovaNotaTVController.swift
//  
//
//  Created by Lia Kassardjian on 16/07/19.
//

import UIKit
import CoreData

class NovaNotaTVController: UITableViewController {

    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var corpoTextView: UITextView!
    
    let modeloNota = ["Nova nota","Escreva aqui sua nota"]
    var conteudo:[String] = []
    
    var context:NSManagedObjectContext?
    var novaNota:Nota?
    var modoEdicao:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewWillAppear(_ animated: Bool) {
        tituloTextField.text = conteudo[0]
        corpoTextView.text = conteudo[1]
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

}
