//
//  DiarioVC.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 15/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData

class DiarioVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var diaLabel: UILabel!
    @IBOutlet weak var voltarButton: UIButton!
    
    var anosPassados:Int = 0
    
    var diaObj:Dia?
    var contagemDias:Int = 0
    
    let titulos = ["Leitura bíblica diária","Lista de oração diária"]
    
    var capitulos:[Capitulo] = []
    var topicosOracao:[String] = []
    var textos:[String] = []
    
    var atributoString:NSMutableAttributedString?
    
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        if let flowLayout = collectionLayout {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 220)
        }
        
        contagemDias = UserDefaults().integer(forKey: "dia")
        diaObj = carregaDia()
        
        if contagemDias <= 1 {
            voltarButton.isHidden = true
        }
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults()
        let tutorial = defaults.bool(forKey: "tutorial")
        if !tutorial {
            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
            if let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "tutorialVC") as? TutorialVC {
                present(tutorialViewController, animated: true, completion: nil)
            }
            defaults.set(true, forKey: "tutorial")
        }
    }
    
    func recuperaCapitulos(dia: Dia) -> [Capitulo]? {
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Capitulo")
            fetchRequest.predicate = NSPredicate(format: "dia = %d", contagemDias)
            
            if let context = context {
                var capitulos = try context.fetch(fetchRequest) as! [Capitulo]
                if capitulos.count <= 0 {
                    recomecaLeitura()
                    capitulos = try context.fetch(fetchRequest) as! [Capitulo]
                }
                return capitulos
            }
            
        } catch {
            print("Erro ao carregar capitulo")
            return nil
        }
        return nil
    }
    
    func recuperaDias(data: Date) -> Dia? {
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dia")
            fetchRequest.predicate = NSPredicate(format: "data = %@", data as NSDate)
            
            if let context = context {
                let dia = try context.fetch(fetchRequest) as! [Dia]
                if dia.count > 0 {
                    return dia.first
                }
            }
            return nil
            
        } catch {
            print("Erro ao carregar dia")
            return nil
        }
    }
    
    func carregaDia() -> Dia? {
       guard let diaObj = recuperaDias(data: Calendario.shared.retornaDataCalendario()) else {
            if let context = context {
                let diaObj = NSEntityDescription.insertNewObject(forEntityName: "Dia", into: context) as! Dia
                diaObj.data = Calendario.shared.retornaDataCalendario() as NSDate
                
                if let cap = recuperaCapitulos(dia: diaObj) {
                    for c in cap {
                        diaObj.addToPossui(c)
                    }
                    capitulos = cap
                }
                
                return diaObj
            }
            return nil
        }
        
        if let cap = recuperaCapitulos(dia: diaObj) {
            capitulos = cap
        }
        return diaObj
    }
    
    func recomecaLeitura() {
        do {
            if let path = Bundle.main.path(forResource: "capitulos", ofType: "json", inDirectory: nil)
            {
                let url = URL(fileURLWithPath: path)
                let jsonData = try Data(contentsOf: url)
                let aulas = try JSONDecoder().decode(Capitulos.self, from: jsonData)
                
                for i in 0...aulas.count-1{
                    if let context = context {
                        let registro = NSEntityDescription.insertNewObject(forEntityName: "Capitulo", into: context) as! Capitulo
                        
                        registro.titulo = aulas[i].titulo
                        registro.lido = false
                        registro.dia = aulas[i].dia + Int32(anosPassados*2)
                        
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                }
                
                print("Inserido com sucesso")
            }
        } catch {
            print("Erro ao inserir os dados dos capitulos")
        }
    }
    
    
    // Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return capitulos.count
        } else {
            return topicosOracao.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicosTVCell") as! TopicosTVCell
        
        if tableView.tag == 1 {
            cell.tituloLabel.text = capitulos[indexPath.row].titulo
            
            if capitulos[indexPath.row].lido {
                marcarConcluido(celula: cell)
            } else {
                desmarcarConcluido(celula: cell)
            }
            
        } else {
            cell.tituloLabel.text = topicosOracao[indexPath.row]
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TopicosTVCell
        if !capitulos[indexPath.row].lido {
            capitulos[indexPath.row].lido = true
            marcarConcluido(celula: cell)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

        } else {
            capitulos[indexPath.row].lido = false
            desmarcarConcluido(celula: cell)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.tag == 2 {
            let exluir = UITableViewRowAction(style: .destructive, title: "Excluir", handler: {(action,indexPath) in
                self.topicosOracao.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            
            let concluir = UITableViewRowAction(style: .normal, title: "Marcar como respondido", handler: {(action, indexPath) in
                self.topicosOracao.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.performSegue(withIdentifier: "novaLembranca", sender: self)
            })
            
            concluir.backgroundColor = #colorLiteral(red: 0.2888143063, green: 0.3528535366, blue: 0.1741557121, alpha: 1)
            
            return [exluir,concluir]
        }
        return []
    }
    
    func desmarcarConcluido(celula: TopicosTVCell) {
        celula.checkImageView.image = nil
        
        atributoString = NSMutableAttributedString(string: celula.tituloLabel.text!)
        atributoString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
        celula.tituloLabel.attributedText = atributoString!
    }
    
    func marcarConcluido(celula: TopicosTVCell) {
        celula.checkImageView.image = UIImage(named: "Check")
        
        atributoString = NSMutableAttributedString(string: celula.tituloLabel.text!)
        atributoString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, atributoString!.length))
        celula.tituloLabel.attributedText = atributoString!
    }
    
    
    // Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titulos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardFixoCVCell", for: indexPath) as! CardFixoCVCell
            cell.topicosTableView.tag = 1
            cell.topicosTableView.reloadData()
            cell.tituloLabel.text = titulos[0]
            cell.adicionarButton.isHidden = true
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardFixoCVCell", for: indexPath) as! CardFixoCVCell
            cell.topicosTableView.tag = 2
            cell.topicosTableView.reloadData()
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
    
    
    // Navegação
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nota = segue.destination as? NovaNotaTVController {
            if segue.identifier == "editarNota" {
                nota.nota = [titulos[2],textos[2]]
            }
        }
    }

    @IBAction func voltarDia(_ sender: Any) {
        Calendario.shared.decrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        contagemDias -= 1
        if contagemDias <= 1 {
            voltarButton.isHidden = true
        }
        
        if contagemDias%2 == 0 {
            anosPassados -= 1
        }
        
        diaObj = carregaDia()
        collectionView.reloadData()
    }
    
    @IBAction func avancarDia(_ sender: Any) {
        Calendario.shared.incrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        contagemDias += 1
        
        if contagemDias%2 == 0 {
            anosPassados += 1
        }
        
        if contagemDias > 1 {
            voltarButton.isHidden = false
        }
        
        diaObj = carregaDia()
        collectionView.reloadData()
    }
    
    @IBAction func salvarNota(_ sender: UIStoryboardSegue){
        if sender.source is NovaNotaTVController {
            if let senderAdd = sender.source as? NovaNotaTVController {
                // adiciona nota
            }
        }
    }

}
