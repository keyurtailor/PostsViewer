//
//  PostDetail+CoreDataProperties.swift
//  
//
//  Created by keyur.tailor on 24/02/21.
//
//

import Foundation
import CoreData


extension PostDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostDetail> {
        return NSFetchRequest<PostDetail>(entityName: "PostDetail")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var favourite: Bool

}
