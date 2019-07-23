//
//  Dia+CoreDataProperties.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 23/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//
//

import Foundation
import CoreData


extension Dia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dia> {
        return NSFetchRequest<Dia>(entityName: "Dia")
    }

    @NSManaged public var data: NSDate?
    @NSManaged public var lista: NSOrderedSet?
    @NSManaged public var possui: NSOrderedSet?

}

// MARK: Generated accessors for lista
extension Dia {

    @objc(insertObject:inListaAtIndex:)
    @NSManaged public func insertIntoLista(_ value: Pedido, at idx: Int)

    @objc(removeObjectFromListaAtIndex:)
    @NSManaged public func removeFromLista(at idx: Int)

    @objc(insertLista:atIndexes:)
    @NSManaged public func insertIntoLista(_ values: [Pedido], at indexes: NSIndexSet)

    @objc(removeListaAtIndexes:)
    @NSManaged public func removeFromLista(at indexes: NSIndexSet)

    @objc(replaceObjectInListaAtIndex:withObject:)
    @NSManaged public func replaceLista(at idx: Int, with value: Pedido)

    @objc(replaceListaAtIndexes:withLista:)
    @NSManaged public func replaceLista(at indexes: NSIndexSet, with values: [Pedido])

    @objc(addListaObject:)
    @NSManaged public func addToLista(_ value: Pedido)

    @objc(removeListaObject:)
    @NSManaged public func removeFromLista(_ value: Pedido)

    @objc(addLista:)
    @NSManaged public func addToLista(_ values: NSOrderedSet)

    @objc(removeLista:)
    @NSManaged public func removeFromLista(_ values: NSOrderedSet)

}

// MARK: Generated accessors for possui
extension Dia {

    @objc(insertObject:inPossuiAtIndex:)
    @NSManaged public func insertIntoPossui(_ value: Capitulo, at idx: Int)

    @objc(removeObjectFromPossuiAtIndex:)
    @NSManaged public func removeFromPossui(at idx: Int)

    @objc(insertPossui:atIndexes:)
    @NSManaged public func insertIntoPossui(_ values: [Capitulo], at indexes: NSIndexSet)

    @objc(removePossuiAtIndexes:)
    @NSManaged public func removeFromPossui(at indexes: NSIndexSet)

    @objc(replaceObjectInPossuiAtIndex:withObject:)
    @NSManaged public func replacePossui(at idx: Int, with value: Capitulo)

    @objc(replacePossuiAtIndexes:withPossui:)
    @NSManaged public func replacePossui(at indexes: NSIndexSet, with values: [Capitulo])

    @objc(addPossuiObject:)
    @NSManaged public func addToPossui(_ value: Capitulo)

    @objc(removePossuiObject:)
    @NSManaged public func removeFromPossui(_ value: Capitulo)

    @objc(addPossui:)
    @NSManaged public func addToPossui(_ values: NSOrderedSet)

    @objc(removePossui:)
    @NSManaged public func removeFromPossui(_ values: NSOrderedSet)

}
