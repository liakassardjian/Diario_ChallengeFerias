//
//  TextFieldDelegate.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 03/04/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var modelo: [String]?
    
    init(modelo: [String]) {
        self.modelo = modelo
    }
    
    func validaTexto(texto: String) -> Bool {
        if texto != "" {
            return true
        }
        return false
    }
    
    func validaTexto(titulo: String, corpo: String) -> Bool {
        if titulo != "" && corpo != "" && titulo != modelo?[0] && corpo != modelo?[1] {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.superview?.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let modelo = modelo else { return }
        if textField.text == modelo[0] {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let modelo = modelo else { return }
        
        if textField.text == "" {
            textField.text = modelo[0]
        }
    }
    
}
