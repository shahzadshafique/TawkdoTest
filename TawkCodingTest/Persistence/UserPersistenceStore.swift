//
//  UserPersistenceStoreProtocol.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//

import Foundation
import CoreData

protocol UserPersistenceStoreProtocol {
    func saveUsers(users: [User],
                   completionHandler: @escaping (Result<Bool, Error>) -> Void)
    func saveDetail(user: User) -> Bool
    func updateDetail(user: User) -> User
    func fetchUsers(offset: Int) -> [User]
    func fetchUser(login: String) -> User?
}

struct UserPersistenceStore: UserPersistenceStoreProtocol {
    private enum UserDefaultKeys {
        static let pageSize = "PageSize"
    }
    private let mainContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    private let userDefault: UserDefaults
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext,
         backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext,
         userDefault: UserDefaults = .standard) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        self.userDefault = userDefault
    }
    
    func saveUsers(users: [User],
                   completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        userDefault.set(users.count, forKey: UserDefaultKeys.pageSize)
        backgroundContext.perform {
            let batchInsertRequest = createBatchInsertRequest(with: users)
            if let fetchResult = try? backgroundContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                completionHandler(.success(success))
                return
            } else {
                completionHandler(.failure(NSError()))
            }
        }
    }
    
    func fetchUsers(offset: Int) -> [User] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:
                                                                    "User")
        let pageSize = userDefault.integer(forKey: UserDefaultKeys.pageSize)
        if  pageSize > 0 {
            fetchRequest.fetchLimit = pageSize
        }
        fetchRequest.predicate = NSPredicate(format: "id > %d", offset)
        var users = [User]()
        do {
            let records = try backgroundContext.fetch(fetchRequest)
            let managedObjectUsers = records as? [UserManagedObject]
            users = managedObjectUsers?.compactMap { User.init(managerObject: $0) } ?? []
        } catch {
            debugPrint("Failed to fetch users")
        }

        return users

    }
    
    func updateDetail(user: User) -> User {
        var user = user
        let existingUser = fetchUser(login: user.login)
        var updatedNote = user.note
        if let note = updatedNote, !note.isEmpty {
            updatedNote = note
        } else if let exisitingNote = existingUser?.note {
            updatedNote = exisitingNote
        }
        
        user.note = updatedNote
        _ = saveDetail(user: user)
        return user
    }
    
    func saveDetail(user: User) -> Bool {
        let userManagedObject = UserManagedObject(context: backgroundContext)
        userManagedObject.populateData(from: user)
        do {
            try backgroundContext.save()
            return true
        }
        catch {
            debugPrint("Failed to save user \(error)")
        }
        return false
    }
    
    func fetchUser(login: String) -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:
                                                                    "User")
        fetchRequest.predicate = NSPredicate(format: "login = %@", login)
        
        do {
            let records = try backgroundContext.fetch(fetchRequest)
            let managedObjectUsers = records as? [UserManagedObject]
            return managedObjectUsers?.compactMap { User.init(managerObject: $0) }.first
        } catch {
            debugPrint("Failed to fetch users")
        }

        return nil
    }
    
    private func createBatchInsertRequest(with users: [User]) -> NSBatchInsertRequest {
        var index = 0
        let total = users.count
        
        let batchInsertRequest = NSBatchInsertRequest(
            entity: UserManagedObject.entity()) { (managedObject: NSManagedObject) -> Bool in
                guard index < total else { return true }
                
                if let userManagedObject = managedObject as? UserManagedObject {
                    let data = users[index]
                    userManagedObject.avatarURL = data.avatarURL
                    userManagedObject.eventsURL = data.eventsURL
                    userManagedObject.followersURL = data.followersURL
                    userManagedObject.followingURL = data.followingURL
                    userManagedObject.gistsURL = data.gistsURL
                    userManagedObject.gravatarId = data.gravatarId
                    userManagedObject.htmlURL = data.htmlURL
                    userManagedObject.id = Int32(data.id)
                    userManagedObject.login = data.login
                    userManagedObject.nodeId = data.nodeId
                    userManagedObject.organizationsURL = data.organizationsURL
                    userManagedObject.receivedEventsURL = data.receivedEventsURL
                    userManagedObject.reposURL = data.reposURL
                    userManagedObject.siteAdmin = data.siteAdmin
                    userManagedObject.starredURL = data.starredURL
                    userManagedObject.subscriptionsURL = data.subscriptionsURL
                    userManagedObject.type = data.type
                    userManagedObject.url = data.url
                    userManagedObject.bio = data.bio
                    userManagedObject.blog = data.blog
                    userManagedObject.company = data.company
                    userManagedObject.createdAt = data.createdAt
                    userManagedObject.email = data.email
                    userManagedObject.followers = Int32(data.followers)
                    userManagedObject.following = Int32(data.following)
                    userManagedObject.hireable = data.hireable
                    userManagedObject.location = data.location
                    userManagedObject.name = data.name
                    userManagedObject.publicGists = data.publicGists
                    userManagedObject.publicRepos = data.publicRepos
                    userManagedObject.twitterUserName = data.twitterUsername
                    userManagedObject.updatedAt = data.updatedAt
                }
                index += 1
                return false
            }
        
        return batchInsertRequest
    }
}
