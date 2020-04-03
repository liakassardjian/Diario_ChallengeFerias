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
    
    var lembrancaFoiDeletada: Bool = false
    var lembrancaDeletada: Lembranca?
    
    var semLembrancaLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let w = collectionView.frame.size.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 142)
        }
        
        semLembrancaLabel = UILabel(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: collectionView.frame.size.width - 100,
                                                  height: 300))
        if let label = semLembrancaLabel {
            self.view.addSubview(label)
        }
        semLembrancaLabel?.text = "Você não tem lembranças ainda. Lembranças são criadas quando pedidos de oração são respondidos."
        semLembrancaLabel?.numberOfLines = 0
        semLembrancaLabel?.textColor = #colorLiteral(red: 0.2789252996, green: 0.1623651087, blue: 0.2221863866, alpha: 1)
        semLembrancaLabel?.textAlignment = .center
        semLembrancaLabel?.translatesAutoresizingMaskIntoConstraints = false
        semLembrancaLabel?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        semLembrancaLabel?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        semLembrancaLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        semLembrancaLabel?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        semLembrancaLabel?.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoreDataManager.shared.fetchLembrancas()
        collectionView.reloadData()

        if lembrancaFoiDeletada {
            if let lembranca = lembrancaDeletada {
                CoreDataManager.shared.deleteLembranca(lembranca: lembranca)
                collectionView.reloadData()
            }
            lembrancaFoiDeletada.toggle()
        }
        
        if CoreDataManager.shared.lembrancas.count == 0 {
            semLembrancaLabel?.isHidden = false
        } else {
            semLembrancaLabel?.isHidden = true
        }
    }

    // Collection View
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CoreDataManager.shared.anos.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreDataManager.shared.lembrancas[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? LembrancaCVCell,
            let data = CoreDataManager.shared.lembrancas[indexPath.section][indexPath.row].data?.data as Date?
            else {
                return UICollectionViewCell()
        }
        cell.dataLabel.text = Calendario.shared.retornaDiaMesString(date: data)
        cell.tituloLabel.text = CoreDataManager.shared.lembrancas[indexPath.section][indexPath.row].titulo
        cell.corpoLabel.text = CoreDataManager.shared.lembrancas[indexPath.section][indexPath.row].corpo
        
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
            
            cabecalho.tituloLabel.text = "\(CoreDataManager.shared.anos[indexPath.section])"
            
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: Int = 0
        if UIDevice.current.orientation == UIDeviceOrientation.portrait ||
            UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            width = Int(collectionView.frame.size.width - 20)
        } else {
            width = Int(collectionView.frame.size.width - 70)
        }
        return CGSize(width: width, height: 142)
    }
    
    // Navegação
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isEditing {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let novaLembrancaVC = segue.destination as? NovaLembrancaVC {
            if segue.identifier == "editarLembranca" {
                if let item = collectionView.indexPathsForSelectedItems?.first {
                    let lembranca = CoreDataManager.shared.lembrancas[item.section][item.row]
                    let titulo = lembranca.titulo
                    let corpo = lembranca.corpo
                    novaLembrancaVC.conteudo = [titulo, corpo] as? [String] ?? ["", ""]
                    novaLembrancaVC.novaLembranca = lembranca
                    novaLembrancaVC.modoEdicao = true
                    novaLembrancaVC.lembrancaCVC = self
                }
            }
        }
    }
    
    @IBAction func salvarEntrada(_ sender: UIStoryboardSegue) {
        if sender.source is NovaLembrancaVC {
            if let senderAdd = sender.source as? NovaLembrancaVC {
                if senderAdd.novaLembranca != nil {
                    collectionView.reloadData()
                }
            }
        }
    }
}
