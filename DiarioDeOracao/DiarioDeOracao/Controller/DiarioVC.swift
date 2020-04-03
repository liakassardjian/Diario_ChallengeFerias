//
//  DiarioVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 15/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

class DiarioVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var diaLabel: UILabel!
    @IBOutlet weak var voltarButton: UIButton!
    
    var dias: [Dia] = []
    var contagemDias: Int = 0
    var anosPassados: Int = 0
    let totalDias: Int = 360
        
    let titulos = ["Leitura bíblica diária", "Lista de oração diária"]
    
    var lembrancaAdicionada: Bool = false
    var tableView: UITableView?
    var indiceDeletado: IndexPath?
    var notaFoiDeletada: Bool = false
    var notaDeletada: Nota?
    
    var atributoString: NSMutableAttributedString?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        if let flowLayout = collectionLayout {
            let w = collectionView.frame.size.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 220)
        }
        
        contagemDias = UserDefaults().integer(forKey: "dia")
        let ultimoDia = UserDefaults().integer(forKey: "ultimoDia")
        let num = Calendario.shared.retornaDiaNumero()
        if ultimoDia != num {
            contagemDias += 1
            UserDefaults().set(contagemDias, forKey: "dia")
            UserDefaults().set(num, forKey: "ultimoDia")
        }
        
        if contagemDias <= 1 {
            voltarButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults()
        let tutorial = defaults.bool(forKey: "tutorial")
        if !tutorial {
            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
            if let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "tutorialVC") as? TutorialVC {
                tutorialViewController.primeiroTutorial = true
                present(tutorialViewController, animated: true, completion: nil)
            }
            defaults.set(true, forKey: "tutorial")
        }
         
        CoreDataManager.shared.fetchDias()
        CoreDataManager.shared.loadDia(contagem: contagemDias)
        if lembrancaAdicionada {
            if let indice = indiceDeletado {
                if let tableView = tableView {
                    CoreDataManager.shared.deletePedido(index: indice.row)
                    tableView.deleteRows(at: [indice], with: .fade)
                }
            }
            lembrancaAdicionada.toggle()
        }
        
        if notaFoiDeletada {
            if let nota = notaDeletada {
                CoreDataManager.shared.deleteNota(nota: nota)
                collectionView.reloadData()
            }
            notaFoiDeletada.toggle()
        }
    }
    
    // Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return CoreDataManager.shared.capitulos.count
        } else {
            return CoreDataManager.shared.pedidos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopicosTVCell") as? TopicosTVCell else { return UITableViewCell() }
        
        if tableView.tag == 1 {
            let capitulos = CoreDataManager.shared.capitulos
            
            cell.tituloLabel.text = capitulos[indexPath.row].titulo
            
            if capitulos[indexPath.row].lido {
                marcarConcluido(celula: cell)
            } else {
                desmarcarConcluido(celula: cell)
            }
            
            cell.urgenciaLabel.isHidden = true
            
        } else {
            let pedidos = CoreDataManager.shared.pedidos

            cell.tituloLabel.text = pedidos[indexPath.row].nome
            let dia = CoreDataManager.shared.dia
            if let concluiu = pedidos[indexPath.row].concluiu,
                concluiu.contains(dia) {
                marcarConcluido(celula: cell)
            } else {
                desmarcarConcluido(celula: cell)
            }
            cell.urgenciaLabel.isHidden = false
            
            switch pedidos[indexPath.row].urgencia {
            case 1:
                cell.urgenciaLabel.text = "!"
            case 2:
                cell.urgenciaLabel.text = "!!"
            case 3:
                cell.urgenciaLabel.text = "!!!"
            default:
                cell.urgenciaLabel.text = ""
            }
            
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TopicosTVCell else { return }
        
        if tableView.tag == 1 {
            let capitulos = CoreDataManager.shared.capitulos
            
            if !capitulos[indexPath.row].lido {
                marcarConcluido(celula: cell)
            } else {
                desmarcarConcluido(celula: cell)
            }
            capitulos[indexPath.row].lido.toggle()
            
        } else {
            let pedidos = CoreDataManager.shared.pedidos
            
            let dia = CoreDataManager.shared.dia
            if let concluiu = pedidos[indexPath.row].concluiu,
                !concluiu.contains(dia) {
                pedidos[indexPath.row].addToConcluiu(dia)
                marcarConcluido(celula: cell)
            } else {
                pedidos[indexPath.row].removeFromConcluiu(dia)
                desmarcarConcluido(celula: cell)
            }

            
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.tag == 2 {
            let exluir = UITableViewRowAction(style: .destructive, title: "Excluir", handler: {(action, indexPath) in
                CoreDataManager.shared.deletePedido(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            
            let concluir = UITableViewRowAction(style: .normal, title: "Marcar como respondido", handler: {(action, indexPath) in
                self.indiceDeletado = indexPath
                self.tableView = tableView
                self.performSegue(withIdentifier: "novaLembranca", sender: self)
            })
            
            concluir.backgroundColor = #colorLiteral(red: 0.2888143063, green: 0.3528535366, blue: 0.1741557121, alpha: 1)
            
            return [exluir, concluir]
        }
        return []
    }
    
    func desmarcarConcluido(celula: TopicosTVCell) {
        celula.checkImageView.image = nil
        
        guard let texto = celula.tituloLabel.text else { return }
        atributoString = NSMutableAttributedString(string: texto)
        atributoString?.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: 0))
        celula.tituloLabel.attributedText = atributoString
    }
    
    func marcarConcluido(celula: TopicosTVCell) {
        celula.checkImageView.image = UIImage(named: "Check")
        
        guard let texto = celula.tituloLabel.text else { return }
        atributoString = NSMutableAttributedString(string: texto)
        atributoString?.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: atributoString?.length ?? 0))
        celula.tituloLabel.attributedText = atributoString
    }
    
    // Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreDataManager.shared.notas.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardFixoCVCell", for: indexPath) as? CardFixoCVCell else {
                return UICollectionViewCell()
            }
            cell.topicosTableView.tag = 1
            cell.topicosTableView.reloadData()
            cell.tituloLabel.text = titulos[0]
            cell.adicionarButton.isHidden = true
            
            return cell
            
        } else if indexPath.row == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardFixoCVCell", for: indexPath) as? CardFixoCVCell else {
                return UICollectionViewCell()
            }
            cell.topicosTableView.tag = 2
            cell.topicosTableView.reloadData()
            cell.tituloLabel.text = titulos[1]
            cell.adicionarButton.isHidden = false
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotasCVCell", for: indexPath) as? NotasCVCell else {
                return UICollectionViewCell()
            }
            
            let notas = CoreDataManager.shared.notas
            
            cell.tituloLabel.text = notas[indexPath.row - 2].titulo
            cell.corpoLabel.text = notas[indexPath.row - 2].corpo
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: collectionView.frame.size.width - 20, height: 220)
    }
    
    // Navegação
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nota = segue.destination as? NovaNotaVC {
            if segue.identifier == "editarNota" {
                if let item = collectionView.indexPathsForSelectedItems?.first {
                    let notaItem = CoreDataManager.shared.notas[item.row - 2]
                    
                    let titulo = notaItem.titulo
                    let corpo = notaItem.corpo
                    nota.conteudo = [titulo, corpo] as? [String] ?? ["", ""]
                    nota.novaNota = notaItem
                    nota.modoEdicao = true
                }
            }
            
            if segue.identifier == "novaNota" {
                nota.conteudo = nota.modeloNota
                nota.modoEdicao = false
            }
            
            nota.diario = self
        }
        
        if let lembranca = segue.destination as? NovaLembrancaVC {
            if segue.identifier == "novaLembranca" {
                lembranca.modoEdicao = false
                lembranca.diario = self
            }
        }
    }

    @IBAction func voltarDia(_ sender: Any) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        Calendario.shared.decrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        if contagemDias%totalDias == 0 {
            anosPassados -= 1
        }
        
        contagemDias -= 1
        
        if contagemDias <= 1 {
            voltarButton.isHidden = true
        }
        
        CoreDataManager.shared.loadDia(contagem: contagemDias)
        collectionView.reloadData()
    }
    
    @IBAction func avancarDia(_ sender: Any) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        Calendario.shared.incrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        if contagemDias%totalDias == 0 {
            anosPassados += 1
        }
        
        contagemDias += 1
        
        if contagemDias > 1 {
            voltarButton.isHidden = false
        }
        
        CoreDataManager.shared.loadDia(contagem: contagemDias)
        collectionView.reloadData()
    }
    
    @IBAction func salvarEntrada(_ sender: UIStoryboardSegue) {
        if sender.source is NovaNotaVC {
            if let senderAdd = sender.source as? NovaNotaVC {
                if let nota = senderAdd.novaNota {
                    CoreDataManager.shared.addNota(nota: nota)
                    collectionView.reloadData()
                }
            }
        }
        
        if sender.source is NovaOracaoTVController {
            if let senderAdd = sender.source as? NovaOracaoTVController {
                if senderAdd.novoPedido != nil {
                    CoreDataManager.shared.fetchPedidos()
                    collectionView.reloadData()
                }
            }
        }
    }
}
