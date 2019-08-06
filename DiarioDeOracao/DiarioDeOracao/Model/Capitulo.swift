//
//  Capitulo.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 22/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import Foundation


typealias Capitulos = [CapituloData]

struct CapituloData: Codable {
    public var titulo: String?
//    public var lido: Bool
    public var dia: Int32
}
