//
//  SampleData.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

@testable import TawkCodingTest
import Foundation
import UIKit

struct SampleData {
    static func createUserListData() -> Data {
        let sampleJSON = """
            [
              {
                "login": "mojombo",
                "id": 1,
                "node_id": "MDQ6VXNlcjE=",
                "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/mojombo",
                "html_url": "https://github.com/mojombo",
                "followers_url": "https://api.github.com/users/mojombo/followers",
                "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
                "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
                "organizations_url": "https://api.github.com/users/mojombo/orgs",
                "repos_url": "https://api.github.com/users/mojombo/repos",
                "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
                "received_events_url": "https://api.github.com/users/mojombo/received_events",
                "type": "User",
                "site_admin": false
              },
              {
                "login": "defunkt",
                "id": 2,
                "node_id": "MDQ6VXNlcjI=",
                "avatar_url": "https://avatars.githubusercontent.com/u/2?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/defunkt",
                "html_url": "https://github.com/defunkt",
                "followers_url": "https://api.github.com/users/defunkt/followers",
                "following_url": "https://api.github.com/users/defunkt/following{/other_user}",
                "gists_url": "https://api.github.com/users/defunkt/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/defunkt/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/defunkt/subscriptions",
                "organizations_url": "https://api.github.com/users/defunkt/orgs",
                "repos_url": "https://api.github.com/users/defunkt/repos",
                "events_url": "https://api.github.com/users/defunkt/events{/privacy}",
                "received_events_url": "https://api.github.com/users/defunkt/received_events",
                "type": "User",
                "site_admin": false
              },
              {
                "login": "pjhyett",
                "id": 3,
                "node_id": "MDQ6VXNlcjM=",
                "avatar_url": "https://avatars.githubusercontent.com/u/3?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/pjhyett",
                "html_url": "https://github.com/pjhyett",
                "followers_url": "https://api.github.com/users/pjhyett/followers",
                "following_url": "https://api.github.com/users/pjhyett/following{/other_user}",
                "gists_url": "https://api.github.com/users/pjhyett/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/pjhyett/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/pjhyett/subscriptions",
                "organizations_url": "https://api.github.com/users/pjhyett/orgs",
                "repos_url": "https://api.github.com/users/pjhyett/repos",
                "events_url": "https://api.github.com/users/pjhyett/events{/privacy}",
                "received_events_url": "https://api.github.com/users/pjhyett/received_events",
                "type": "User",
                "site_admin": false
              }
        ]
        """
        
        return sampleJSON.data(using: .utf8)!
    }
    
    static func createUserData() -> Data {
        let sampleJSON = """
            {
              "login": "mojombo",
              "id": 1,
              "node_id": "MDQ6VXNlcjE=",
              "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
              "gravatar_id": "",
              "url": "https://api.github.com/users/mojombo",
              "html_url": "https://github.com/mojombo",
              "followers_url": "https://api.github.com/users/mojombo/followers",
              "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
              "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
              "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
              "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
              "organizations_url": "https://api.github.com/users/mojombo/orgs",
              "repos_url": "https://api.github.com/users/mojombo/repos",
              "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
              "received_events_url": "https://api.github.com/users/mojombo/received_events",
              "type": "User",
              "site_admin": false,
              "name": "Tom Preston-Werner",
              "company": "@chatterbugapp, @redwoodjs, @preston-werner-ventures ",
              "blog": "http://tom.preston-werner.com",
              "location": "San Francisco",
              "email": null,
              "hireable": null,
              "bio": null,
              "twitter_username": "mojombo",
              "public_repos": 64,
              "public_gists": 62,
              "followers": 23228,
              "following": 11,
              "created_at": "2007-10-20T05:24:19Z",
              "updated_at": "2022-10-08T15:17:05Z"
            }
        """
        
        return sampleJSON.data(using: .utf8)!
    }
    
    static func createUserListArray(name: String = "test", isSeen: Bool = false, notes: String = "") -> [User] {
        var users = [User]()
        for i in 1...30 {
            users.append(User(avatarURL: "www.test.com", bio: "", blog: "", company: "", createdAt: nil, email: nil, eventsURL: "www.testEventURL.com", followers: 24, followersURL: "", following: 20, followingURL: "www.testfollowing.com",  gistsURL: "www.testgists.com", gravatarId: "", hireable: "", htmlURL: "", id: i, isSeen: isSeen, location: "test location", login: "uskde-\(i)", name: name, nodeId: "usr-node-\(i)",note: notes, organizationsURL: "", publicGists: "", publicRepos: "", receivedEventsURL: "", reposURL: "", siteAdmin: false, starredURL: "", subscriptionsURL: "", twitterUsername: "", type: "User", updatedAt: nil, url: ""))
        }
        
        return users
    }
    
    static func sampleImageData() -> Data {
        UIImage(systemName: "person.circle")!.pngData()!
    }
}
