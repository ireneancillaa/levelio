//
//  HabitEntity+CoreDataProperties.swift
//  
//
//  Created by Irene Ancilla Chow on 21/10/26.
//
//  This file was automatically generated and should not be edited.
//

public import Foundation
public import CoreData


public typealias HabitEntityCoreDataPropertiesSet = NSSet

extension HabitEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitEntity> {
        return NSFetchRequest<HabitEntity>(entityName: "HabitEntity")
    }

    @NSManaged nonisolated public var colorName: String?
    @NSManaged nonisolated public var desc: String?
    @NSManaged nonisolated public var frequency: String?
    @NSManaged nonisolated public var habitId: UUID?
    @NSManaged nonisolated public var isCompleted: Bool
    @NSManaged nonisolated public var time: String?
    @NSManaged nonisolated public var title: String?
    @NSManaged nonisolated public var userId: UUID?
    @NSManaged nonisolated public var xpReward: Int64

}

extension HabitEntity : Identifiable {

}
