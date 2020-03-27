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
    
    static let shared = CoreDataManager()
    
    private init() {
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        dias = []
    }
    
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
        
//        let dia = diasList[contagem - 1]
//
//        let capitulosTemp: [Capitulo] = dia.leitura?.array as? [Capitulo] ?? []
        //        capitulos = capitulosTemp
        //        recuperaPedidos(dia: dia)
        //        notas = recuperaNotas(dia: dia)
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
    
    func fetchCapitulos(dia: Dia, contagem: Int) {
        do {
            guard let context = self.context else { return }
            var capitulosData = [Capitulo]()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Capitulo")
            fetchRequest.predicate = NSPredicate(format: "dia = %d", contagem)
            guard let capitulos = try context.fetch(fetchRequest) as? [Capitulo] else { return }
            
            if capitulos.count <= 0 {
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
            if let path = Bundle.main.path(forResource: "capitulos", ofType: "json", inDirectory: nil) {
                let url = URL(fileURLWithPath: path)
                let jsonData = try Data(contentsOf: url)
                let cap = try JSONDecoder().decode(Capitulos.self, from: jsonData)
                
                for i in 0...cap.count-1 {
                    if let context = context {
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
            }
        } catch {
            print("Erro ao inserir os dados dos capitulos")
        }
    }
    
}
