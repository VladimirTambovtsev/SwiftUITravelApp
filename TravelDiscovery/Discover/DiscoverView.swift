//
//  DiscoverView.swift
//  TravelDiscovery
//
//  Created by Владимир on 06.02.2021.
//

import SwiftUI


extension Color {
    static let discoverBackground = Color(.init(white: 0.9, alpha: 1))
    static let defaultBackground = Color("defaultBackground")
}

struct DiscoverView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    
    var body: some View {
        NavigationView {
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9921568627, green: 0.7176470588, blue: 0.3137254902, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.3867110903, blue: 0.3643574446, alpha: 1))]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                
                Color.defaultBackground
                    .offset(y: 400)
                
                ScrollView {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Where do you want to go?")
                        Spacer()
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(10)
                    .padding(16)
                    
                    DiscoverCategoriesView()
                    
                    VStack {
                        PopularDestinationView()
                        PopularRestaurantsView()
                        TrendingCreatorsView()
                    }
                    .background(Color.defaultBackground)
                    .cornerRadius(16)
                    .padding(.top, 32)
                }
            }.navigationTitle("Discover")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .colorScheme(.dark)
        
        DiscoverView()
            .colorScheme(.light)
    }
}

