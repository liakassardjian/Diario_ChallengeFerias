//
//  DiarioVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 15/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class DiarioVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var diaLabel: UILabel!
    
    // dados provisorios para teste
    let titulos = ["Leitura bíblica diária","Lista de oração diária","Nota pessoal"]
    let textos = ["3/3 concluídos","4/5 concluídos","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]
    
    let topicosLeitura = ["Gênesis 1","I Crônicas 1","Salmo 1"]
    let topicosOracao = ["Família","Saúde","Trabalho"]
    
    var atributoString:NSMutableAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        if let flowLayout = collectionLayout {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return topicosLeitura.count
        } else {
            return topicosOracao.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicosTVCell") as! TopicosTVCell
        
        if tableView.tag == 1 {
            cell.tituloLabel.text = topicosLeitura[indexPath.row]
        } else {
            cell.tituloLabel.text = topicosOracao[indexPath.row]
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TopicosTVCell
        if let image = cell.checkImageView.image {
            cell.checkImageView.image = nil
            cell.tituloLabel.textColor = UIColor.black
            
            atributoString = NSMutableAttributedString(string: cell.tituloLabel.text!)
            atributoString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
            cell.tituloLabel.attributedText = atributoString!
            
        } else {
            cell.checkImageView.image = UIImage(named: "Check")
            cell.tituloLabel.textColor = #colorLiteral(red: 0.2625154257, green: 0.150888145, blue: 0.2062340677, alpha: 1)
            
            atributoString = NSMutableAttributedString(string: cell.tituloLabel.text!)
            atributoString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, atributoString!.length))
            cell.tituloLabel.attributedText = atributoString!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titulos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardFixoCVCell", for: indexPath) as! CardFixoCVCell
            cell.topicosTableView.tag = 1
            cell.tituloLabel.text = titulos[0]
            cell.adicionarButton.isHidden = true
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardFixoCVCell", for: indexPath) as! CardFixoCVCell
            cell.topicosTableView.tag = 2
            cell.tituloLabel.text = titulos[1]
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotasCVCell", for: indexPath) as! NotasCVCell
            cell.tituloLabel.text = titulos[indexPath.row]
            cell.corpoLabel.text = textos[indexPath.row]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            performSegue(withIdentifier: "editarNota", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let lista = segue.destination as? ListasTVController {
//            if segue.identifier == "leituraBiblicaSegue" {
//                lista.navigationItem.title = "Leitura bíblica"
//                lista.navigationItem.rightBarButtonItem = .none
//                lista.dados = topicosLeitura
//            } else {
//                lista.navigationItem.title = "Lista de oração"
//                lista.dados = topicosOracao
//            }
//        } else
        if let nota = segue.destination as? NovaNotaTVController {
            if segue.identifier == "editarNota" {
                nota.nota = [titulos[2],textos[2]]
            }
        }
    }

    @IBAction func voltarDia(_ sender: Any) {
        Calendario.shared.decrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
    }
    
    @IBAction func avancarDia(_ sender: Any) {
        Calendario.shared.incrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
    }
    
    @IBAction func salvarNota(_ sender: UIStoryboardSegue){
        if sender.source is NovaNotaTVController {
            if let senderAdd = sender.source as? NovaNotaTVController {
                // adiciona nota
            }
        }
    }

}
