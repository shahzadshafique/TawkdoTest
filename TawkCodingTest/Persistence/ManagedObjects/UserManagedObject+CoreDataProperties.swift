//
//  UserManagedObject+CoreDataProperties.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 02/11/2022.
//
//

import Foundation
import CoreData


extension UserManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserManagedObject> {
        return NSFetchRequest<UserManagedObject>(entityName: "User")
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var bio: String?
    @NSManaged public var blog: String?
    @NSManaged public var company: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var email: String?
    @NSManaged public var eventsURL: String?
    @NSManaged public var followers: Int32
    @NSManaged public var followersURL: String?
    @NSManaged public var following: Int32
    @NSManaged public var followingURL: String?
    @NSManaged public var gistsURL: String?
    @NSManaged public var gravatarId: String?
    @NSManaged public var hireable: String?
    @NSManaged public var htmlURL: String?
    @NSManaged public var id: Int32
    @NSManaged public var isSeen: Bool
    @NSManaged public var location: String?
    @NSManaged public var login: String?
    @NSManaged public var name: String?
    @NSManaged public var nodeId: String?
    @NSManaged public var note: String?
    @NSManaged public var organizationsURL: String?
    @NSManaged public var publicGists: String?
    @NSManaged public var publicRepos: String?
    @NSManaged public var receivedEventsURL: String?
    @NSManaged public var reposURL: String?
    @NSManaged public var siteAdmin: Bool
    @NSManaged public var starredURL: String?
    @NSManaged public var subscriptionsURL: String?
    @NSManaged public var twitterUserName: String?
    @NSManaged public var type: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var url: String?
    
    func populateData(from user: User) {
        self.avatarURL = user.avatarURL
        self.bio = user.bio
        self.blog = user.blog
        self.company = user.company
        self.createdAt = user.createdAt
        self.email = user.email
        self.eventsURL = user.eventsURL
        self.followers = Int32(user.followers)
        self.followersURL = user.followersURL
        self.following = Int32(user.following)
        self.followingURL = user.followingURL
        self.gistsURL = user.gistsURL
        self.gravatarId = user.gravatarId
        self.hireable = user.hireable
        self.htmlURL = user.htmlURL
        self.id = Int32(user.id)
        self.isSeen = user.isSeen
        self.location = user.location
        self.login = user.login
        self.name = user.name
        self.nodeId = user.nodeId
        self.note = user.note
        self.organizationsURL = user.organizationsURL
        self.publicGists = user.publicGists
        self.publicRepos = user.publicRepos
        self.receivedEventsURL = user.receivedEventsURL
        self.reposURL = user.reposURL
        self.siteAdmin = user.siteAdmin
        self.starredURL = user.starredURL
        self.subscriptionsURL = user.subscriptionsURL
        self.twitterUserName = user.twitterUsername
        self.type = user.type
        self.updatedAt = user.updatedAt
        self.url = user.url
    }
}

extension UserManagedObject : Identifiable {

}
