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

class LembrancasCVController: UICollectionViewController {
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    var context:NSManagedObjectContext?
    
    var lembrancas:[[Lembranca]] = []
    var anos:[Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if let flowLayout = collectionLayout {
            let w = self.collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 142)
        }
        
//        carregaLembrancas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        carregaLembrancas()
        collectionView.reloadData()
    }
    
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
        }
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
