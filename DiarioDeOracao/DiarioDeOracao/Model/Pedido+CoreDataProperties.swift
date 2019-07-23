//
//  Pedido+CoreDataProperties.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 23/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//
//

import Foundation
import CoreData


extension Pedido {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pedido> {
        return NSFetchRequest<Pedido>(entityName: "Pedido")
    }

    @NSManaged public var nome: String?
    @NSManaged public var urgencia: Int32
    @NSManaged public var dataFinal: NSDate?
    @NSManaged public var orado: Bool
    @NSManaged public var pertence: NSOrderedSet?

}

// MARK: Generated accessors for pertence
extension Pedido {

    @objc(insertObject:inPertenceAtIndex:)
    @NSManaged public func insertIntoPertence(_ value: Dia, at idx: Int)

    @objc(removeObjectFromPertenceAtIndex:)
    @NSManaged public func removeFromPertence(at idx: Int)

    @objc(insertPertence:atIndexes:)
    @NSManaged public func insertIntoPertence(_ values: [Dia], at indexes: NSIndexSet)

    @objc(removePertenceAtIndexes:)
    @NSManaged public func removeFromPertence(at indexes: NSIndexSet)

    @objc(replaceObjectInPertenceAtIndex:withObject:)
    @NSManaged public func replacePertence(at idx: Int, with value: Dia)

    @objc(replacePertenceAtIndexes:withPertence:)
    @NSManaged public func replacePertence(at indexes: NSIndexSet, with values: [Dia])

    @objc(addPertenceObject:)
    @NSManaged public func addToPertence(_ value: Dia)

    @objc(removePertenceObject:)
    @NSManaged public func removeFromPertence(_ value: Dia)

    @objc(addPertence:)
    @NSManaged public func addToPertence(_ values: NSOrderedSet)

    @objc(removePertence:)
    @NSManaged public func removeFromPertence(_ values: NSOrderedSet)

}
