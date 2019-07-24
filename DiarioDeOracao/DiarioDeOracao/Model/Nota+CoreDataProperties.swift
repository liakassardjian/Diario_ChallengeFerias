//
//  Nota+CoreDataProperties.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 24/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//
//

import Foundation
import CoreData


extension Nota {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Nota> {
        return NSFetchRequest<Nota>(entityName: "Nota")
    }

    @NSManaged public var titulo: String?
    @NSManaged public var corpo: String?

}
