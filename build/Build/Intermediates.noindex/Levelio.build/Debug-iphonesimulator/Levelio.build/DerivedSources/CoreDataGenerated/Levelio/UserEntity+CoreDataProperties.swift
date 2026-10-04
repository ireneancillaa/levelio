//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Irene Ancilla Chow on 22/09/26.
//
//  This file was automatically generated and should not be edited.
//

public import Foundation
public import CoreData


public typealias UserEntityCoreDataPropertiesSet = NSSet

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged nonisolated public var birthDate: Date?
    @NSManaged nonisolated public var createdDate: Date?
    @NSManaged nonisolated public var email: String?
    @NSManaged nonisolated public var fullName: String?
    @NSManaged nonisolated public var gender: String?
    @NSManaged nonisolated public var id: UUID?
    @NSManaged nonisolated public var levelioId: String?
    @NSManaged nonisolated public var password: String?
    @NSManaged nonisolated public var role: String?
    @NSManaged nonisolated public var streak: Int64

}

extension UserEntity : Identifiable {

}
