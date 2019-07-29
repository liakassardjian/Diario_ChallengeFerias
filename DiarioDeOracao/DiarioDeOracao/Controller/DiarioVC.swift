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
    
    
    var dia:Dia?
    var contagemDias:Int = 0
    var anosPassados:Int = 0
    
    let totalDias:Int = 270
    
    let titulos = ["Leitura bíblica diária","Lista de oração diária"]
    
    var capitulos:[Capitulo] = []
    var pedidos:[Pedido] = []
    var notas:[Nota] = []
    
    var atributoString:NSMutableAttributedString?
    
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
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
        
        dia = carregaDia()
        
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
    
    
    // Core Data
    
    func recuperaCapitulos() -> [Capitulo]? {
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
    
    func recuperaPedidos() -> [Pedido]? {
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pedido")
            fetchRequest.predicate = NSPredicate(format: "dataFinal >= %@", Calendario.shared.retornaDataCalendario() as CVarArg)
            
            if let context = context {
                let pedidos = try context.fetch(fetchRequest) as! [Pedido]
                return pedidos
            }
            
        } catch {
            print("Erro ao carregar capitulo")
            return nil
        }
        return nil
    }
    
    func recuperaNotas(dia: Dia) -> [Nota] {
        var notasTemp:[Nota] = []
        for i in 0..<(dia.tem!.count) {
            let n = dia.tem![i]
            notasTemp.append(n as! Nota)
        }
        
        return notasTemp
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
                
                if let cap = recuperaCapitulos() {
                    for c in cap {
                        diaObj.addToLeitura(c)
                        
                    }
                    capitulos = cap
                }
                
                if let ped = recuperaPedidos() {
                    for p in ped {
                        diaObj.addToLista(p)
                    }
                    pedidos = ped
                }
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                return diaObj
            }
            return nil
        }
        
        if let cap = recuperaCapitulos() {
            capitulos = cap
        }
        if let ped = recuperaPedidos() {
            pedidos = ped
        }
        
        notas = recuperaNotas(dia: diaObj)
        
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
                        registro.dia = aulas[i].dia + Int32(anosPassados*totalDias)
                        
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
            return pedidos.count
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
            
            cell.urgenciaLabel.isHidden = true
            
        } else {
            cell.tituloLabel.text = pedidos[indexPath.row].nome
            
            if let dia = dia {
                if (pedidos[indexPath.row].concluiu?.contains(dia))! {
                    marcarConcluido(celula: cell)
                } else {
                    desmarcarConcluido(celula: cell)
                }                
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
        let cell = tableView.cellForRow(at: indexPath) as! TopicosTVCell
        
        if tableView.tag == 1{
            if !capitulos[indexPath.row].lido {
                marcarConcluido(celula: cell)
            } else {
                desmarcarConcluido(celula: cell)
            }
            capitulos[indexPath.row].lido.toggle()
            
        } else {
            if let dia = dia {
                if !(pedidos[indexPath.row].concluiu?.contains(dia))! {
                    marcarConcluido(celula: cell)
                    pedidos[indexPath.row].addToConcluiu(dia)
                } else {
                    desmarcarConcluido(celula: cell)
                    pedidos[indexPath.row].removeFromConcluiu(dia)
                }
            }
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.tag == 2 {
            let exluir = UITableViewRowAction(style: .destructive, title: "Excluir", handler: {(action,indexPath) in
                self.context?.delete(self.pedidos[indexPath.row])
                self.pedidos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            
            let concluir = UITableViewRowAction(style: .normal, title: "Marcar como respondido", handler: {(action, indexPath) in
                self.context?.delete(self.pedidos[indexPath.row])
                self.pedidos.remove(at: indexPath.row)
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
        return notas.count + 2
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
            cell.adicionarButton.isHidden = false
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotasCVCell", for: indexPath) as! NotasCVCell
            cell.tituloLabel.text = notas[indexPath.row - 2].titulo
            cell.corpoLabel.text = notas[indexPath.row - 2].corpo
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            performSegue(withIdentifier: "editarNota", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: collectionView.frame.size.width - 20, height: 220)
    }
    
    
    // Navegação
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nota = segue.destination as? NovaNotaTVController {
            if segue.identifier == "editarNota" {
                if let item = collectionView.indexPathsForSelectedItems?.first {
                    let titulo = notas[item.row - 2].titulo
                    let corpo = notas[item.row - 2].corpo
                    nota.conteudo = [titulo,corpo] as! [String]
                    nota.novaNota = notas[item.row - 2]
                    nota.modoEdicao = true
                }
            }
            
            if segue.identifier == "novaNota" {
                nota.conteudo = nota.modeloNota
                nota.modoEdicao = false
            }
        }
        
        if let lembranca = segue.destination as? NovaLembrancaTVController {
            if segue.identifier == "novaLembranca" {
                lembranca.data = dia
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
        
        if contagemDias%totalDias == 0 {
            anosPassados -= 1
        }
        
        dia = carregaDia()
        collectionView.reloadData()
    }
    
    @IBAction func avancarDia(_ sender: Any) {
        Calendario.shared.incrementaDia()
        diaLabel.text = Calendario.shared.retornaDiaAtual()
        
        contagemDias += 1
        
        if contagemDias%totalDias == 0 {
            anosPassados += 1
        }
        
        if contagemDias > 1 {
            voltarButton.isHidden = false
        }
        
        dia = carregaDia()
        collectionView.reloadData()
    }
    
    @IBAction func salvarEntrada(_ sender: UIStoryboardSegue){
        if sender.source is NovaNotaTVController {
            if let senderAdd = sender.source as? NovaNotaTVController {
                if let nota = senderAdd.novaNota {
                    dia?.addToTem(nota)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    if let dia = dia {
                        notas = recuperaNotas(dia: dia)
                    }
                    collectionView.reloadData()
                }
            }
        }
        
        if sender.source is NovaOracaoTVController {
            if let senderAdd = sender.source as? NovaOracaoTVController {
                if let pedido = senderAdd.novoPedido {
                    dia?.addToLista(pedido)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    if let ped = recuperaPedidos() {
                        pedidos = ped
                    }
                    collectionView.reloadData()
                }
            }
        }
    }

}
