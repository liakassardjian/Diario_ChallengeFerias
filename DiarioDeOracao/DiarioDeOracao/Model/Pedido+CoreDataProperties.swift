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
    @NSManaged public var concluiu: NSOrderedSet?

}

// MARK: Generated accessors for concluiu
extension Pedido {

    @objc(insertObject:inConcluiuAtIndex:)
    @NSManaged public func insertIntoConcluiu(_ value: Dia, at idx: Int)

    @objc(removeObjectFromConcluiuAtIndex:)
    @NSManaged public func removeFromConcluiu(at idx: Int)

    @objc(insertConcluiu:atIndexes:)
    @NSManaged public func insertIntoConcluiu(_ values: [Dia], at indexes: NSIndexSet)

    @objc(removeConcluiuAtIndexes:)
    @NSManaged public func removeFromConcluiu(at indexes: NSIndexSet)

    @objc(replaceObjectInConcluiuAtIndex:withObject:)
    @NSManaged public func replaceConcluiu(at idx: Int, with value: Dia)

    @objc(replaceConcluiuAtIndexes:withConcluiu:)
    @NSManaged public func replaceConcluiu(at indexes: NSIndexSet, with values: [Dia])

    @objc(addConcluiuObject:)
    @NSManaged public func addToConcluiu(_ value: Dia)

    @objc(removeConcluiuObject:)
    @NSManaged public func removeFromConcluiu(_ value: Dia)

    @objc(addConcluiu:)
    @NSManaged public func addToConcluiu(_ values: NSOrderedSet)

    @objc(removeConcluiu:)
    @NSManaged public func removeFromConcluiu(_ values: NSOrderedSet)

}
