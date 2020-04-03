//
//  TextViewDelegate.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 03/04/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import Foundation
import UIKit

class TextViewDelegate: NSObject, UITextViewDelegate {
    
    var modelo: [String]?
    
    init(modelo: [String]) {
        self.modelo = modelo
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == modelo?[1] {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = modelo?[1]
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
    
    func validaTexto(titulo: String, corpo: String) -> Bool {
        if titulo != "" && corpo != "" && titulo != modelo?[0] && corpo != modelo?[1] {
            return true
        }
        return false
    }
}
