//
//  CoreDataManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/11/24.
//

import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyChat", managedObjectModel: createCoreDataModel())
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createCoreDataModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // 엔티티 정의
        let entity = NSEntityDescription()
        entity.name = "MyChat"
        entity.managedObjectClassName = NSStringFromClass(MyChat.self)
        
        // 속성 정의
        entity.properties = [ 
            attribute(name: "id", attributeType: .UUIDAttributeType, isOptional: false),
            attribute(name: "chatName", attributeType: .stringAttributeType, isOptional: false),
            attribute(name: "chatImage", attributeType: .stringAttributeType, isOptional: false),
            attribute(name: "hostID", attributeType: .UUIDAttributeType, isOptional: false),
            attribute(name: "participantID", attributeType: .binaryDataAttributeType, isOptional: true),
            attribute(name: "chatOption", attributeType: .binaryDataAttributeType, isOptional: true)
        ]

        model.entities = [entity]
        return model
    }
    
    func attribute(name: String, attributeType: NSAttributeType, isOptional: Bool)-> NSAttributeDescription{
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = attributeType
        attribute.isOptional = isOptional
        return attribute
    }
    
    func saveChat(_ chat: Chat){
        if let entity = NSEntityDescription.entity(forEntityName: "MyChat", in: viewContext){
            let chatInfo = NSManagedObject(entity: entity, insertInto: viewContext)
             chatInfo.setValue(chat.id, forKey: "id")
             chatInfo.setValue(chat.chatName, forKey: "chatName")
             chatInfo.setValue(chat.chatImage, forKey: "chatImage")
             chatInfo.setValue(chat.hostID, forKey: "hostID")
            if let participantIDArray = try? JSONEncoder().encode(chat.participantID) {
                chatInfo.setValue(participantIDArray, forKey: "participantID")
            }
            if let chatOptionArray = try? JSONEncoder().encode(chat.chatOption) {
                chatInfo.setValue(chatOptionArray, forKey: "chatOption")
            }
        }
        
        saveContext()
    }
    
    func fetchChat()-> [Chat]{
        var chatArray: [Chat] = []
        do{
            guard let myChatArray = try viewContext.fetch(MyChat.fetchRequest()) as? [MyChat] else {
                return [] }
            
            myChatArray.forEach{
                if let participantIDArray = try? JSONDecoder().decode([UUID].self, from: $0.participantID),
                   let chatOptionArray = try? JSONDecoder().decode([Int].self, from: $0.chatOption){
                    chatArray.append(Chat(id: $0.id, chatName: $0.chatName, chatImage: $0.chatImage, hostID: $0.hostID, participantID: participantIDArray, chatOption: chatOptionArray))
                }
            }
            
        } catch{
            print("🌀 불러오기 Error: \(error.localizedDescription)")
        }
        
        return chatArray
    }
    
    func saveContext(){
        do {
            try viewContext.save()
        } catch {
            print("🌀 저장 Error: \(error.localizedDescription)")
        }
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MyChat")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(batchDeleteRequest)
        } catch {
            print("Failed to delete data: \(error)")
        }
    }
    
}
