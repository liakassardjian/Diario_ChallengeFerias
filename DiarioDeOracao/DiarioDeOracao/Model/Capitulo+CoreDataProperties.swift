//
//  Capitulo+CoreDataProperties.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 22/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//
//

import Foundation
import CoreData


extension Capitulo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Capitulo> {
        return NSFetchRequest<Capitulo>(entityName: "Capitulo")
    }

    @NSManaged public var titulo: String?
    @NSManaged public var lido: Bool
    @NSManaged public var dia: Int32

}
