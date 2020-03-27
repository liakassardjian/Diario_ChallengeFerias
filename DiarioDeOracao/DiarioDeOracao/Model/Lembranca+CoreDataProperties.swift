//
//  Lembranca+CoreDataProperties.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 24/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//
//

import Foundation
import CoreData

extension Lembranca {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lembranca> {
        return NSFetchRequest<Lembranca>(entityName: "Lembranca")
    }

    @NSManaged public var titulo: String?
    @NSManaged public var corpo: String?
    @NSManaged public var data: Dia?

}
