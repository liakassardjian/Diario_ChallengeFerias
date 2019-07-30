//
//  LembrancasCVController.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 18/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "lembranca"

class LembrancasCVController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var deletarButton: UIBarButtonItem!
    
    var context:NSManagedObjectContext?
    
    var lembrancas:[[Lembranca]] = []
    var anos:[Int] = []
    
    var semLembrancaLabel:UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        

        if let flowLayout = collectionLayout {
            let w = collectionView.frame.size.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 142)
        }
        
        semLembrancaLabel = UILabel(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: collectionView.frame.size.width - 100,
                                                  height: 300))
        semLembrancaLabel?.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        semLembrancaLabel?.text = "Você não tem lembranças ainda. Lembranças são criadas quando pedidos de oração são respondidos."
        semLembrancaLabel?.textColor = #colorLiteral(red: 0.2789252996, green: 0.1623651087, blue: 0.2221863866, alpha: 1)
        semLembrancaLabel?.numberOfLines = 0
        semLembrancaLabel?.textAlignment = .center
        semLembrancaLabel?.sizeToFit()
        semLembrancaLabel?.isHidden = true
        
        if let label = semLembrancaLabel {
            self.view.addSubview(label)
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        carregaLembrancas()
        collectionView.reloadData()
        
        if lembrancas.count == 0 {
            semLembrancaLabel?.isHidden = false
        } else {
            semLembrancaLabel?.isHidden = true
        }
        
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        semLembrancaLabel?.frame = CGRect(x: 0,
                                          y: 0,
                                          width: collectionView.frame.size.width - 100,
                                          height: 300)
        semLembrancaLabel?.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        semLembrancaLabel?.sizeToFit()
    }
    
    
    // Core Data
    
    func carregaLembrancas() {
        do {
            var lem:[Lembranca] = []
            if let context = context {
                lem = try context.fetch(Lembranca.fetchRequest())
            }
            
            for l in lem {
                let data = l.data?.data as! Date
                let ano = Calendario.shared.retornaAno(date: data)
                if !anos.contains(ano) {
                    anos.append(ano)
                }
            }
            anos.sort(by: >)
            
            lembrancas = []
            for _ in anos {
                let novoVetor:[Lembranca] = []
                lembrancas.append(novoVetor)
            }
            
            for l in lem {
                let data = l.data?.data as! Date
                let ano = Calendario.shared.retornaAno(date: data)
                if let i = anos.firstIndex(of: ano) {
                    if !lembrancas[i].contains(l) {
                        lembrancas[i].insert(l, at: 0)
                    }
                }
            }
        } catch {
            print("Erro ao carregar lembranças")
            return
        }
    }

    
    // Collection View
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return anos.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lembrancas[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LembrancaCVCell
        
        let data = lembrancas[indexPath.section][indexPath.row].data?.data as! Date

        cell.dataLabel.text = Calendario.shared.retornaDiaMesString(date: data)
        cell.tituloLabel.text = lembrancas[indexPath.section][indexPath.row].titulo
        cell.corpoLabel.text = lembrancas[indexPath.section][indexPath.row].corpo
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let cabecalho = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "cabecalho",
                    for: indexPath) as? CabecalhoCollectionReusableView
                else {
                    fatalError("Invalid view type")
            }
            
            cabecalho.tituloLabel.text = "\(anos[indexPath.section])"
            
            return cabecalho
            
        case UICollectionView.elementKindSectionFooter:
            guard
                let rodape = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "rodape",
                    for: indexPath) as? RodapeCollectionReusableView
                else {
                    fatalError("Invalid view type")
            }
            
            return rodape
            
        default:
            assert(false, "Invalid element type")
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation == UIDeviceOrientation.portrait ||
            UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            return CGSize(width: collectionView.frame.size.width - 20, height: 142)
        } else {
            return CGSize(width: collectionView.frame.size.width - 70, height: 142)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! LembrancaCVCell
            cell.isInEditingMode = editing
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            deletarButton.isEnabled = false
        } else {
            deletarButton.isEnabled = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deletarButton.isEnabled = false
        }
    }
    
    // Navegação
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isEditing {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let lembranca = segue.destination as? NovaLembrancaTVController {
            if segue.identifier == "editarLembranca" {
                if let item = collectionView.indexPathsForSelectedItems?.first {
                    let titulo = lembrancas[item.section][item.row].titulo
                    let corpo = lembrancas[item.section][item.row].corpo
                    lembranca.conteudo = [titulo,corpo] as! [String]
                    lembranca.novaLembranca = lembrancas[item.section][item.row]
                    lembranca.modoEdicao = true
                }
            }
        }
    }
    
    @IBAction func salvarEntrada(_ sender: UIStoryboardSegue){
        if sender.source is NovaLembrancaTVController {
            if let senderAdd = sender.source as? NovaLembrancaTVController {
                if let lembranca = senderAdd.novaLembranca {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    
    // Ações
    
    @IBAction func deletarLembranca(_ sender: Any) {
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            
            for item in selectedCells {
                self.context?.delete(self.lembrancas[item.section][item.row])
                self.lembrancas[item.section].remove(at: item.row)
                
            }
            
            collectionView.deleteItems(at: selectedCells)
            
            for s in 0..<collectionView.numberOfSections {
                if collectionView.numberOfItems(inSection: s) == 0 {
                    self.lembrancas.remove(at: s)
                    anos.remove(at: s)
                    collectionView.deleteSections([s])
                }
            }
            deletarButton.isEnabled = false
        }
    }
}
