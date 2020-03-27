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
    
    var context: NSManagedObjectContext?
    
    var lembrancas = [[Lembranca]]()
    var anos = [Int]()
    
    var lembrancaFoiDeletada: Bool = false
    var lembrancaDeletada: Lembranca?
    
    var semLembrancaLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
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
        carregaLembrancas()
        collectionView.reloadData()

        if lembrancaFoiDeletada {
            if let lembranca = lembrancaDeletada {
                self.context?.delete(lembranca)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                
                carregaLembrancas()
                collectionView.reloadData()
            }
            lembrancaFoiDeletada.toggle()
        }
        
        if lembrancas.count == 0 {
            semLembrancaLabel?.isHidden = false
        } else {
            semLembrancaLabel?.isHidden = true
        }
    }
    
    // Core Data
    
    func carregaLembrancas() {
        do {
            var lem = [Lembranca]()
            if let context = context {
                lem = try context.fetch(Lembranca.fetchRequest())
            }
            
            var a = [Int]()
            for l in lem {
                if let data = l.data?.data as Date? {
                    let ano = Calendario.shared.retornaAno(date: data)
                    if !a.contains(ano) {
                        a.append(ano)
                    }
                }
            }
            a.sort(by: >)
            anos = a
            
            lembrancas = []
            for _ in anos {
                let novoVetor = [Lembranca]()
                lembrancas.append(novoVetor)
            }
            
            for l in lem {
                if let data = l.data?.data as Date? {
                    let ano = Calendario.shared.retornaAno(date: data)
                    if let i = anos.firstIndex(of: ano) {
                        if !lembrancas[i].contains(l) {
                            lembrancas[i].insert(l, at: 0)
                        }
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? LembrancaCVCell,
            let data = lembrancas[indexPath.section][indexPath.row].data?.data as Date?
            else {
                return UICollectionViewCell()
        }
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
        if let lembranca = segue.destination as? NovaLembrancaVC {
            if segue.identifier == "editarLembranca" {
                if let item = collectionView.indexPathsForSelectedItems?.first {
                    let titulo = lembrancas[item.section][item.row].titulo
                    let corpo = lembrancas[item.section][item.row].corpo
                    lembranca.conteudo = [titulo, corpo] as? [String] ?? ["", ""]
                    lembranca.novaLembranca = lembrancas[item.section][item.row]
                    lembranca.modoEdicao = true
                    lembranca.lembrancaCVC = self
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
