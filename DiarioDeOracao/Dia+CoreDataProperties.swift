//
//  Dia+CoreDataProperties.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 05/08/19.
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
    @NSManaged public var leitura: NSOrderedSet?
    @NSManaged public var tem: NSOrderedSet?
    @NSManaged public var lista: NSOrderedSet?

}

// MARK: Generated accessors for leitura
extension Dia {

    @objc(insertObject:inLeituraAtIndex:)
    @NSManaged public func insertIntoLeitura(_ value: Capitulo, at idx: Int)

    @objc(removeObjectFromLeituraAtIndex:)
    @NSManaged public func removeFromLeitura(at idx: Int)

    @objc(insertLeitura:atIndexes:)
    @NSManaged public func insertIntoLeitura(_ values: [Capitulo], at indexes: NSIndexSet)

    @objc(removeLeituraAtIndexes:)
    @NSManaged public func removeFromLeitura(at indexes: NSIndexSet)

    @objc(replaceObjectInLeituraAtIndex:withObject:)
    @NSManaged public func replaceLeitura(at idx: Int, with value: Capitulo)

    @objc(replaceLeituraAtIndexes:withLeitura:)
    @NSManaged public func replaceLeitura(at indexes: NSIndexSet, with values: [Capitulo])

    @objc(addLeituraObject:)
    @NSManaged public func addToLeitura(_ value: Capitulo)

    @objc(removeLeituraObject:)
    @NSManaged public func removeFromLeitura(_ value: Capitulo)

    @objc(addLeitura:)
    @NSManaged public func addToLeitura(_ values: NSOrderedSet)

    @objc(removeLeitura:)
    @NSManaged public func removeFromLeitura(_ values: NSOrderedSet)

}

// MARK: Generated accessors for tem
extension Dia {

    @objc(insertObject:inTemAtIndex:)
    @NSManaged public func insertIntoTem(_ value: Nota, at idx: Int)

    @objc(removeObjectFromTemAtIndex:)
    @NSManaged public func removeFromTem(at idx: Int)

    @objc(insertTem:atIndexes:)
    @NSManaged public func insertIntoTem(_ values: [Nota], at indexes: NSIndexSet)

    @objc(removeTemAtIndexes:)
    @NSManaged public func removeFromTem(at indexes: NSIndexSet)

    @objc(replaceObjectInTemAtIndex:withObject:)
    @NSManaged public func replaceTem(at idx: Int, with value: Nota)

    @objc(replaceTemAtIndexes:withTem:)
    @NSManaged public func replaceTem(at indexes: NSIndexSet, with values: [Nota])

    @objc(addTemObject:)
    @NSManaged public func addToTem(_ value: Nota)

    @objc(removeTemObject:)
    @NSManaged public func removeFromTem(_ value: Nota)

    @objc(addTem:)
    @NSManaged public func addToTem(_ values: NSOrderedSet)

    @objc(removeTem:)
    @NSManaged public func removeFromTem(_ values: NSOrderedSet)

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
