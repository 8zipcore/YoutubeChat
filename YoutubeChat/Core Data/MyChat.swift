//
//  MyChat.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/21/24.
//

import CoreData

@objc(Entity)
public class MyChat: NSManagedObject {
  @NSManaged public var id: UUID
  @NSManaged public var chatName: String
  @NSManaged public var chatImage: String
  @NSManaged public var hostID: UUID
  @NSManaged public var participantID: Data
  @NSManaged public var chatOption: Data
  @NSManaged public var message: Data
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MyChat> {
    return NSFetchRequest<MyChat>(entityName: "MyChat")
  }
}
