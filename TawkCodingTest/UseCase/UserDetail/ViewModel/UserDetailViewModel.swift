//
//  UserDetailViewModel.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import Foundation
import UIKit
import Combine

final class UserDetailViewModel: ObservableObject {
    private var user: User
    private let userDataProvider: UserDataProviderProtocol
    private let imageProvider: ImageProviderProtocol
    private let reachabilityService = ReachabilityService.shared
    private var cancellable: AnyCancellable?
    
    @Published private(set) var following: String = ""
    @Published private(set) var followers: String = ""
    @Published var notes: String = ""
    @Published private(set) var image: UIImage = UIImage(systemName: "person.circle")!
    @Published private(set) var profileData: [[String: String]] = []
    @Published private(set) var state: Status = .idle
    @Published private(set) var isNetworkConnectionAvailable = true
    @Published private(set) var alertMessage: String = ""
    @Published var presentAlert = false
    
    init(user: User,
         userDataProvider: UserDataProviderProtocol = UserDataProvider(),
         imageProvider: ImageProviderProtocol = ImageProvider()) {
        self.user = user
        self.userDataProvider = userDataProvider
        self.imageProvider = imageProvider
        handleNetworkConnection()
        loadProfileImage()
        loadProfileDetail()
    }
    
    private func handleNetworkConnection() {
        cancellable = self.reachabilityService.objectWillChange.sink { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isNetworkConnectionAvailable =  self.reachabilityService.isNetworkAvailable
            }
            
            if self.reachabilityService.isNetworkAvailable &&
               self.state == .failed {
                self.loadProfileImage()
            }
        }
    }
    
    private func loadProfileImage() {
        guard let url = user.avatarURL else { return }
        
        imageProvider.fetchImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if let image = image {
                        self?.image = image
                    }
                }
            case .failure(_): break
            }
        }
    }
    
    private func loadProfileDetail() {
        guard state != .loading else { return }
        DispatchQueue.main.async { [weak self] in
            self?.state = .loading
        }
        userDataProvider.fetchUserDetail(login: user.login) { result in
            switch result {
            case .success(let user):
                self.user = user
                DispatchQueue.main.async {
                    self.updateData()
                    self.state = .completed
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.state = .failed
                }
            }
        }
    }
    
    private func updateData() {
        if let note = user.note {
            self.notes = note
        }
        
        self.following = "\(String(string: .following)): \(user.following)"
        self.followers = "\(String(string: .followers)): \(user.followers)"
        
        var profileData = [[String: String]]()
        if let name = user.name,
            !name.isEmpty {
            profileData.append(["\(String(string: .name)):": name])
        }
        
        if let company = user.company,
            !company.isEmpty {
            profileData.append(["\(String(string: .company)):": company])
        }
        
        if let location = user.location,
            !location.isEmpty {
            profileData.append(["\(String(string: .location)):": location])
        }
        
        if let blog = user.blog,
            !blog.isEmpty {
            profileData.append(["\(String(string: .blog)):": blog])
        }
        
        if let email = user.email {
            profileData.append(["\(String(string: .email)):": email])
        }
        
        self.profileData = profileData
        
    }
    
    func saveNote() {
        guard user.note != notes.trimmingCharacters(in: .whitespaces) else {
            return
        }
        
        user.note = notes.trimmingCharacters(in: .whitespaces)
        var message = String(string: .saveErrorMessage)
        if userDataProvider.save(user: user) {
            message = "\(String(string: .note)) \(String(string: .saveSuccessMessage))"
        }
        
        alertMessage = message
        presentAlert = true
    }
    
    
}
