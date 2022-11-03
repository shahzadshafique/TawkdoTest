//
//  UserDetailView.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import SwiftUI

struct UserDetailView: View {
    
    
    @ObservedObject var viewModel: UserDetailViewModel
    
    var body: some View {
        
        if viewModel.state == .completed {
            createContent()
        } else if !viewModel.isNetworkConnectionAvailable{
            // TODO: this can be improved with toast, for now using full screen
            HStack {
                Image(systemName: "wifi.slash")
                Text(String(string: .networkErrorMessage))
            }
        } else if viewModel.state == .failed {
            Text(String(string: .generalErrorMessage))
        } else if viewModel.state == .loading {
            ProgressView()
        }
        
    }
    
    private func createContent() -> some View {
        return ScrollViewReader {_ in
            VStack {
                VStack {
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.red)
                
                HStack {
                    Spacer()
                    Text(viewModel.followers).frame(alignment: .leading)
                    Spacer()
                    Text(viewModel.following).frame(alignment: .trailing)
                    Spacer()
                }
                
                if !viewModel.profileData.isEmpty {
                    createProfileView()
                }
                
                createNotesSection()
                
                createSaveButton()
                    .alert(isPresented: $viewModel.presentAlert) {
                        Alert(title: Text(""), message: Text(viewModel.alertMessage), dismissButton: .default(Text(String(string: .okButtonTitle))))
                    }
                
            }
            .padding()
        }
        .onTapGesture {
            endEditing()
        }
        .manageKeyboard()
    }
    
    
    private func createProfileView() -> some View {
        return VStack(alignment: .leading) {
            
            ForEach(viewModel.profileData, id: \.self) { item in
                if let key = item.keys.first,
                   let value = item.values.first {
                    HStack(alignment: .top) {
                        Text(key).font(.system(size: 16, weight: .bold))
                        Text(value)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(2)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .border(.black, width: 2)
    }
    
    private func createNotesSection() -> some View {
        return VStack(alignment: .leading) {
            Text("\(String(string: .note)):")
            TextEditor(text: $viewModel.notes)
                .font(.system(size: 14))
                .foregroundColor(Color.black)
                .frame(height: 150)
                .border(Color.black, width: 2)
        }
        .padding(.vertical, 15)
    }
    
    private func createSaveButton() -> some View {
        return HStack {
            Button(action: {
                viewModel.saveNote()
            }, label: {
                Text(String(string: .save))
                    .frame(width: 60, height: 30)
                    .border(.black, width: 1)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .shadow(
                                color: Color.black.opacity(0.8),
                                radius: 4,
                                x: 2,
                                y: 5
                            )
                    )
            })
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(viewModel: UserDetailViewModel(user: User(avatarURL: "", bio: "", blog: "", company: "Test", createdAt: "", email: "test@gmail.com", eventsURL: "", followers: 12, followersURL: "", following: 23, followingURL: "", gistsURL: "", gravatarId: "", hireable: "", htmlURL: "", id: 1, isSeen: false, location: "USA", login: "abc", name: "test", nodeId: "23423", note: "", organizationsURL: "", publicGists: "", publicRepos: "", receivedEventsURL: "", reposURL: "", siteAdmin: false, starredURL: "", subscriptionsURL: "", twitterUsername: "", type: "User", updatedAt: "", url: "")))
    }
}
