//
//  CoreDataManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/11/24.
//

import CoreData

enum Entity: String{
    case myChat = "MyChat"
}

class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YoutubeChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveMyChatInfo(_ myChatInfo: MyChatInfo){
        if let entity = NSEntityDescription.entity(forEntityName: Entity.myChat.rawValue, in: viewContext){
            let chatInfo = NSManagedObject(entity: entity, insertInto: viewContext)
            chatInfo.setValue(myChatInfo.chatID, forKey: "chat_id")
            chatInfo.setValue(myChatInfo.chatName, forKey: "chat_name")
            chatInfo.setValue(myChatInfo.chatImage, forKey: "chat_image")
            chatInfo.setValue(myChatInfo.participantNumber, forKey: "participant_number")
            chatInfo.setValue(myChatInfo.lastMessage, forKey: "last_message")
            chatInfo.setValue(myChatInfo.timestamp, forKey: "timestamp")
        }
        
        saveContext()
    }
    
    func fetchMyChatInfo()-> [MyChatInfo]{
        var myChatInfoArray: [MyChatInfo] = []
        do{
            guard let myChatInfos = try viewContext.fetch(MyChat.fetchRequest()) as? [MyChat] else {
                return [] }
            
            myChatInfos.forEach{
                myChatInfoArray.append(MyChatInfo(chatID: $0.chat_id!,
                                                  chatName: $0.chat_name!,
                                                  chatImage: $0.chat_image!,
                                                  participantNumber: Int($0.participant_number),
                                                  lastMessage: $0.last_message!,
                                                  timestamp: $0.timestamp!))
            }
            
        } catch{
            print("🌀 불러오기 Error: \(error.localizedDescription)")
        }
        
        return myChatInfoArray
    }
    
    func saveContext(){
        do {
            try viewContext.save()
        } catch {
            print("🌀 저장 Error: \(error.localizedDescription)")
        }
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Entity.myChat.rawValue)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(batchDeleteRequest)
        } catch {
            print("Failed to delete data: \(error)")
        }
    }
    
}
