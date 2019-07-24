//
//  NovaLembrancaTVController.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 18/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

class NovaLembrancaTVController: UITableViewController {

    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var corpoTextView: UITextView!
    
    var context:NSManagedObjectContext?
    
    var data:Dia?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let context = context {
            let novaLembranca = NSEntityDescription.insertNewObject(forEntityName: "Lembranca", into: context) as! Lembranca
            novaLembranca.titulo = leTextField(textField: tituloTextField)
            novaLembranca.corpo = leTextView(textView: corpoTextView)
            
            if let data = data {
                novaLembranca.data = data
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

}
