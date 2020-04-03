//
//  CoreDataHelper.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 27/03/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    var context: NSManagedObjectContext?
    var dias: [Dia]
    var dia: Dia
    var capitulos: [Capitulo]
    var pedidos: [Pedido]
    var notas: [Nota]
    var lembrancas: [[Lembranca]]
    var anos: [Int]
    
    static let shared = CoreDataManager()
    
    private init() {
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        dias = []
        capitulos = []
        pedidos = []
        notas = []
        lembrancas = []
        anos = []
        dia = Dia()
    }
    
    // MARK: - Dias
    
    func fetchDias() {
        do {
            if let context = context {
                dias = try context.fetch(Dia.fetchRequest())
            }
        } catch {
            print("Erro ao carregar dias")
        }
    }
    
    func loadDia(contagem: Int) {
        if dias.count < contagem {
            guard let novoDia = createDia(contagem: contagem) else { return }
            dias.append(novoDia)
        }
        
        dia = dias[contagem - 1]
        
        if let capitulosTemp = dia.leitura?.array as? [Capitulo] {
            capitulos = capitulosTemp
        }
        fetchPedidos()
        fetchNotas()
    }
    
    func createDia(contagem: Int) -> Dia? {
        guard let context = self.context,
            let dia = NSEntityDescription.insertNewObject(forEntityName: "Dia", into: context) as? Dia
            else { return nil }
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        dia.data = Calendario.shared.retornaDataCalendario() as NSDate
        fetchCapitulos(dia: dia, contagem: contagem)
        return dia
    }
    
    // MARK: - Capitulos
    
    func fetchCapitulos(dia: Dia, contagem: Int) {
        do {
            guard let context = self.context else { return }
            var capitulosData = [Capitulo]()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Capitulo")
            fetchRequest.predicate = NSPredicate(format: "dia = %d", contagem)
            guard let cap = try context.fetch(fetchRequest) as? [Capitulo] else { return }
            
            if cap.count <= 0 {
                recomecaLeitura()
                guard let novosCapitulos = try context.fetch(fetchRequest) as? [Capitulo] else { return }
                capitulosData = novosCapitulos
            } else {
                capitulosData = capitulos
            }
            
            for c in capitulosData {
                dia.addToLeitura(c)
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            
        } catch {
            print("Erro ao carregar capitulo")
            return
        }
    }
    
    func recomecaLeitura() {
        do {
            guard let context = self.context else { return }
            
            if let path = Bundle.main.path(forResource: "capitulos", ofType: "json", inDirectory: nil) {
                let url = URL(fileURLWithPath: path)
                let jsonData = try Data(contentsOf: url)
                let cap = try JSONDecoder().decode(Capitulos.self, from: jsonData)
                
                for i in 0...cap.count-1 {
                    
                    let registro = NSEntityDescription.insertNewObject(forEntityName: "Capitulo", into: context) as? Capitulo
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                    
                    if let registro = registro {
                        registro.titulo = cap[i].titulo
                        registro.lido = false
                        registro.dia = cap[i].dia + Int32(Calendario.shared.anosPassados * 360)
                        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                    }
                    
                }
            }
        } catch {
            print("Erro ao inserir os dados dos capitulos")
        }
    }
    
    // MARK: - Pedidos
    
    func fetchPedidos() {
        do {
            guard let context = self.context else { return }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pedido")
            fetchRequest.predicate = NSPredicate(format: "dataFinal >= %@", Calendario.shared.retornaDataCalendario() as CVarArg)
            
            guard let pedidos = try context.fetch(fetchRequest) as? [Pedido] else { return }
            
            self.pedidos = pedidos
        } catch {
            print("Erro ao carregar capitulo")
            return
        }
    }
    
    func deletePedido(index: Int) {
        context?.delete(pedidos[index])
        pedidos.remove(at: index)
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func createPedido(nome: String, urgencia: Int, data: Date) -> Pedido? {
        guard let context = self.context else { return nil }
        
        let novoPedido = NSEntityDescription.insertNewObject(forEntityName: "Pedido", into: context) as? Pedido
        
        novoPedido?.nome = nome
        novoPedido?.urgencia = Int32(urgencia)
        novoPedido?.dataFinal = data as NSDate
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        return novoPedido
    }
    
    // MARK: - Notas
    
    func fetchNotas() {
        guard let notasTemp = dia.tem else { return }
        
        for i in 0..<(notasTemp.count) {
            guard let n = notasTemp[i] as? Nota else { return }
            notas.append(n)
        }
    }
    
    func addNota(nota: Nota) {
        dia.addToTem(nota)
        fetchNotas()
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func deleteNota(nota: Nota) {
        dia.removeFromTem(nota)
        self.context?.delete(nota)
        fetchNotas()
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func createNota() -> Nota? {
        guard let context = self.context else { return nil }
        
        let novaNota = NSEntityDescription.insertNewObject(forEntityName: "Nota", into: context) as? Nota
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        return novaNota
    }
    
    // MARK: - Lembranças
    
    func fetchLembrancas() {
        guard let context = self.context else { return }
        
        do {
            var lem = [Lembranca]()
            lem = try context.fetch(Lembranca.fetchRequest())
            
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
    
    func deleteLembranca(lembranca: Lembranca) {
        self.context?.delete(lembranca)
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        CoreDataManager.shared.fetchLembrancas()
    }
    
    func createLembranca() -> Lembranca? {
        guard let context = self.context else { return nil }

        let novaLembranca = NSEntityDescription.insertNewObject(forEntityName: "Lembranca", into: context) as? Lembranca
        return novaLembranca
    }
    
}
