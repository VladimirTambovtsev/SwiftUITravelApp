//
//  CategoryDetailView.swift
//  TravelDiscovery
//
//  Created by Владимир on 09.02.2021.
//

import SwiftUI


import Kingfisher
import SDWebImageSwiftUI


class CategoryDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var places = [Place]()
    @Published var errorMessage = ""
    
    init(name: String) {
        
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/category?name="+name.lowercased()
        
        guard let url = URL(string: urlString
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("url does not exist")
            self.isLoading = false
            return
            
        }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let statusCode = (res as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                    print("status code: ", statusCode)
                    self.isLoading = false
                    self.errorMessage = "Bad status: \(statusCode)"
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    self.places = try JSONDecoder().decode([Place].self, from: data)
                } catch {
                    print("error: ", error)
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
                }
            }.resume()
    }
}

struct CategoryDetailsView: View {
    private let name: String
    @ObservedObject private var vm: CategoryDetailsViewModel
    
    init(name: String) {
        print("Loaded CategoriesDetails View and making network request for \(name)")
        self.name = name
        self.vm = .init(name: name)
    }
    
    var body: some View {
        ZStack {
            if vm.isLoading {
                VStack {
                    ActivityIndicatorView()
                    Text("Loading..")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding()
                .background(Color.black)
                .cornerRadius(8)
                
            } else {
                ZStack {
                    if !vm.errorMessage.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "xmark.octagon.fill")
                                .font(.system(size: 64, weight: .semibold))
                                .foregroundColor(.red)
                            Text(vm.errorMessage)
                        }
                    }

                    ScrollView {
                        ForEach(vm.places, id: \.self) { place in
                            VStack(alignment: .leading, spacing: 0) {
//                                KFImage(URL(string: place.thumbnail))
                                WebImage(url: URL(string: place.thumbnail))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFill()
                                Text(place.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding()
                            }
                            .asTile()
                            .padding()
                        }
                    }.navigationBarTitle("Category", displayMode: .inline)
                }
            }
        }
    }
}



struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailsView(name: "Food")
    }
}
