//
//  User.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 30/10/2022.
//

struct User: Identifiable {
    let avatarURL: String?
    let bio: String?
    let blog: String?
    let company: String?
    let createdAt: String?
    let email: String?
    let eventsURL: String?
    let followers: Int
    let followersURL: String?
    let following: Int
    let followingURL: String?
    let gistsURL: String?
    let gravatarId: String?
    let hireable: String?
    let htmlURL: String?
    let id: Int
    var isSeen: Bool
    let location: String?
    let login: String
    let name: String?
    let nodeId: String
    var note: String?
    let organizationsURL: String?
    let publicGists: String?
    let publicRepos: String?
    let receivedEventsURL: String?
    let reposURL: String?
    let siteAdmin: Bool
    let starredURL: String?
    let subscriptionsURL: String?
    let twitterUsername: String?
    let type: String?
    let updatedAt: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case eventsURL = "events_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case gravatarId = "gravatar_id"
        case htmlURL = "html_url"
        case id = "id"
        case login = "login"
        case nodeId = "node_id"
        case organizationsURL = "organizations_url"
        case receivedEventsURL = "received_events_url"
        case reposURL = "repos_url"
        case siteAdmin = "site_admin"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case type = "type"
        case url = "url"
        case bio = "bio"
        case blog = "blog"
        case company = "company"
        case createdAt = "created_at"
        case email = "email"
        case followers = "followers"
        case following = "following"
        case hireable = "hireable"
        case location = "location"
        case name = "name"
        case publicGists = "public_gists"
        case publicRepos = "public_repos"
        case twitterUsername = "twitter_username"
        case updatedAt = "updated_at"
    }
}

extension User: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avatarURL = try? values.decode(String.self, forKey: .avatarURL)
        bio = try? values.decode(String.self, forKey: .bio)
        blog = try? values.decode(String.self, forKey: .blog)
        company = try? values.decode(String.self, forKey: .company)
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        email = try? values.decode(String.self, forKey: .email)
        eventsURL = try? values.decode(String.self, forKey: .eventsURL)
        if let followers = try? values.decode(Int.self, forKey: .followers) {
            self.followers = followers
        } else {
            self.followers = 0
        }
        
        if let following = try? values.decode(Int.self, forKey: .following) {
            self.following = following
        } else {
            self.following = 0
        }
        followersURL = try? values.decode(String.self, forKey: .followersURL)
        followingURL = try? values.decode(String.self, forKey: .followersURL)
        gistsURL = try? values.decode(String.self, forKey: .gistsURL)
        gravatarId = try? values.decode(String.self, forKey: .gravatarId)
        hireable = try? values.decode(String.self, forKey: .hireable)
        htmlURL = try? values.decode(String.self, forKey: .htmlURL)
        id = try! values.decode(Int.self, forKey: .id)
        isSeen = false
        location = try? values.decode(String.self, forKey: .location)
        login = try! values.decode(String.self, forKey: .login)
        name = try? values.decode(String.self, forKey: .name)
        nodeId = try! values.decode(String.self, forKey: .nodeId)
        note = ""
        organizationsURL = try? values.decode(String.self, forKey: .organizationsURL)
        publicGists = try? values.decode(String.self, forKey: .publicGists)
        publicRepos = try? values.decode(String.self, forKey: .publicRepos)
        receivedEventsURL = try? values.decode(String.self, forKey: .receivedEventsURL)
        reposURL = try? values.decode(String.self, forKey: .reposURL)
        siteAdmin = false//try values.decode(Bool.self, forKey: .siteAdmin)
        starredURL = try? values.decode(String.self, forKey: .starredURL)
        subscriptionsURL = try? values.decode(String.self, forKey: .subscriptionsURL)
        twitterUsername = try? values.decode(String.self, forKey: .twitterUsername)
        type = try? values.decode(String.self, forKey: .type)
        updatedAt = try? values.decode(String.self, forKey: .updatedAt)
        url = try? values.decode(String.self, forKey: .url)
    }
}

extension User {
    init?(managerObject: UserManagedObject) {
        guard let login = managerObject.login,
              let nodeId = managerObject.nodeId else {
                  return nil
              }
        self.avatarURL = managerObject.avatarURL
        self.bio = managerObject.bio
        self.blog = managerObject.blog
        self.company = managerObject.company
        self.createdAt = managerObject.createdAt
        self.email = managerObject.email
        self.eventsURL = managerObject.eventsURL
        self.followers = Int(managerObject.followers)
        self.followersURL = managerObject.followersURL
        self.following = Int(managerObject.following)
        self.followingURL = managerObject.followingURL
        self.gistsURL = managerObject.gistsURL
        self.gravatarId = managerObject.gravatarId
        self.hireable = managerObject.hireable
        self.htmlURL = managerObject.htmlURL
        self.id = Int(managerObject.id)
        self.isSeen = managerObject.isSeen
        self.location = managerObject.location
        self.login = login
        self.name = managerObject.name
        self.nodeId = nodeId
        self.note = managerObject.note
        self.organizationsURL = managerObject.organizationsURL
        self.publicGists = managerObject.publicGists
        self.publicRepos = managerObject.publicRepos
        self.receivedEventsURL = managerObject.receivedEventsURL
        self.reposURL = managerObject.reposURL
        self.siteAdmin = managerObject.siteAdmin
        self.starredURL = managerObject.starredURL
        self.subscriptionsURL = managerObject.subscriptionsURL
        self.twitterUsername = managerObject.twitterUserName
        self.type = managerObject.type
        self.updatedAt = managerObject.updatedAt
        self.url = managerObject.url
    }
}
