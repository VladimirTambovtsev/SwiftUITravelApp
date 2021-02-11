//
//  UserDetailsView.swift
//  TravelDiscovery
//
//  Created by Владимир on 11.02.2021.
//

import SwiftUI
import Kingfisher

struct UserDetails: Decodable, Hashable {
    let username, firstName, lastName, profileImage: String
    let followers, following: Int
    let posts: [Post]
}

struct Post: Decodable, Hashable {
    let title, imageUrl, views: String
    let hashtags: [String]
}

class UserDetailsViewModel: ObservableObject {
    @Published var userDetails: UserDetails?
    
    init(userId: Int) {
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(userId)") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                do {
                    self.userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                    print("userDetails: ", self.userDetails)
                } catch let jsonError {
                    print("unknow error: \(jsonError)")
                }
            }
        }.resume()
    }
}

struct UserDetailsView: View {
    @ObservedObject var vm: UserDetailsViewModel
    let user: User
    
    init(user: User) {
        self.user = user
        self.vm = .init(userId: user.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(user.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top)
                
                Text("\(self.vm.userDetails?.firstName  ?? "") \(self.vm.userDetails?.lastName  ?? "")")
                    .font(.system(size: 14, weight: .semibold))
                
                HStack {
                    Text("@\(self.vm.userDetails?.username ?? "") •")
                        .font(.system(size: 12, weight: .regular))
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 10, weight: .semibold))
                    Text("2541")
                }
                
                Text("YouTuber, Vlogger, Designer")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.lightGray))
                
                
                HStack(spacing: 12) {
                    VStack {
                        Text("\(self.vm.userDetails?.followers  ?? 0)")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Followers")
                            .font(.system(size: 9, weight: .regular))
                    }
                    Spacer()
                        .frame(width: 0.5, height: 12)
                        .background(Color(.lightGray))
                    
                    VStack {
                        Text("\(self.vm.userDetails?.following ?? 0)")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Following")
                            .font(.system(size: 9, weight: .regular))
                    }
                }
                
                HStack(spacing: 16) {
                    Button(action: {}, label: {
                        HStack {
                            Spacer()
                            Text("Follow")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color.orange)
                        .cornerRadius(100)
                    })
                    Button(action: {}, label: {
                        HStack {
                            Spacer()
                            Text("Contact")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color(white: 0.9))
                        .cornerRadius(100)
                    })
                }
                .font(.system(size: 11, weight: .semibold))
                .padding()
                
                ForEach(vm.userDetails?.posts ?? [], id: \.self) { post in
                    VStack(alignment: .leading) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        
                        HStack {
                            Image("amy")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 34)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.system(size: 13, weight: .semibold))
                                Text("\(post.views) views")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }.padding(.horizontal, 8)
                        
                        HStack {
                            ForEach(post.hashtags ?? [], id: \.self) { hashtag in
                                Text("#\(hashtag)")
                                    .foregroundColor(Color(#colorLiteral(red: 0.2381744332, green: 0.7431853047, blue: 1, alpha: 0.9279977154)))
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(#colorLiteral(red: 0.9489255137, green: 0.9568973117, blue: 0.9239861521, alpha: 1)))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.bottom)
                        .padding(.horizontal, 8)
                    }
//                    .frame(height: 200)
                    .background(Color(white: 1))
                    .cornerRadius(12)
                    .shadow(color: .init(white: 0.8), radius: 5, x: 0, y: 4)
                }
                
            }.padding(.horizontal)
            
        }.navigationBarTitle(user.name, displayMode: .inline)
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(user: .init(id: 0, name: "Any", imageName: "amy"))
    }
}
