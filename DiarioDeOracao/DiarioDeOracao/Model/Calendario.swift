//
//  Calendario.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 15/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import Foundation

class Calendario {
    static let shared = Calendario()
    
    private var data:Date
    private var calendario:Calendar
    
    public var dia:Int
    public var diaDaSemana:Int
    public var mes:Int
    public var ano:Int
    
    public let meses = ["janeiro","fevereiro","março","abril","maio","junho","julho","agosto","setembro","outubro","novembro","dezembro"]
    
    public let diasDaSemana = ["Domingo","Segunda-feira","Terça-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sábado"]
    
    public var diasNoMes = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    private init() {
        data = Date()
        calendario = Calendar.current
        dia = calendario.component(.day, from: data)
        diaDaSemana = calendario.component(.weekday, from: data)
        mes = calendario.component(.month, from: data)
        ano = calendario.component(.year, from: data)
    }
    
    public func incrementaDia() {
        if dia == diasNoMes[mes - 1] {
            switch mes {
            case 12:
                mes = 1
                ano += 1
                verificaAnoBissexto()
            default:
                mes += 1
            }
            dia = 1
        }
        else {
            dia += 1
        }
        
        switch diaDaSemana {
        case 7:
            diaDaSemana = 1
        default:
            diaDaSemana += 1
        }

    }
    
    public func decrementaDia() {
        if dia == 1 {
            switch mes {
            case 1:
                mes = 12
                ano -= 1
                verificaAnoBissexto()
            default:
                mes -= 1
            }
            dia = diasNoMes[mes - 1]
        }
        else {
            dia -= 1
        }
        
        switch diaDaSemana {
        case 1:
            diaDaSemana = 7
        default:
            diaDaSemana -= 1
        }
    }
    
    private func verificaAnoBissexto() {
        if ano%4 == 0 {
            diasNoMes[1] = 29
        } else {
            diasNoMes[1] = 28
        }
    }

    public func retornaDiaAtual() -> String {
        return "\(diasDaSemana[diaDaSemana - 1]), \(dia) de \(meses[mes - 1]) de \(ano)"
    }
    
    public func retornaDataAtual() -> Date {
        return data
    }
    
}
