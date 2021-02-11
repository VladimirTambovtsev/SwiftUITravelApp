//
//  DiscoverCategoriesView.swift
//  TravelDiscovery
//
//  Created by Владимир on 09.02.2021.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct DiscoverCategoriesView: View {
    
    let categories: [Category] = [
        .init(name: "Art", imageName: "paintpalette.fill"),
        .init(name: "Sports", imageName: "sportscourt.fill"),
        .init(name: "Live events", imageName: "music.mic"),
        .init(name: "Food", imageName: "tray.fill"),
        .init(name: "History", imageName: "books.vertical.fill"),
        .init(name: "Hot", imageName: "flame.fill"),
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(categories, id: \.self) { category in
                    NavigationLink(
                        destination: NavigationLazyView(CategoryDetailsView(name: category.name)),
                        label: {
                            VStack(spacing: 8) {
        //                        Spacer()
                                Image(systemName: category.imageName)
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(#colorLiteral(red: 0.9843137255, green: 0.6431372549, blue: 0.2509803922, alpha: 1)))
                                    .frame(width: 64, height: 64)
                                    .background(Color.white)
                                    .cornerRadius(64)
        //                            .shadow(color: .gray, radius: 4, x: 0.0, y: 2)
                                Text(category.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            }.frame(width: 64)
                        })
                }
            }.padding(.horizontal)
        }
    }
}


struct DiscoverCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
        ZStack {
            Color.orange
            DiscoverCategoriesView()
        }
    }
}
