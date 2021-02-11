//
//  TrendingCreators.swift
//  TravelDiscovery
//
//  Created by Владимир on 09.02.2021.
//

import SwiftUI

struct TrendingCreatorsView: View {
    let users: [User] = [
        .init(id: 0, name: "Amy Adams", imageName: "amy"),
        .init(id: 1, name: "Billy", imageName: "billy"),
        .init(id: 2, name: "Sam Smith", imageName: "sam"),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Trending Creators")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(users, id: \.self) { user in
                        NavigationLink(
                            destination: NavigationLazyView(UserDetailsView(user: user)),
                            label: {
                                DiscoverUserView(user: user)
                                    .padding(.bottom)
                            })
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct DiscoverUserView: View {
    let user: User
    
    var body: some View {
            VStack {
            Image(user.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .cornerRadius(25)
            Text(user.name)
                .font(.system(size: 11, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.label))
        }
        .frame(width: 60)
        .shadow(color: .gray, radius: 4, x: 0.0, y: 2)
    }
}

struct TrendingCreators_Previews: PreviewProvider {
    static var previews: some View {
        TrendingCreatorsView()
    }
}
