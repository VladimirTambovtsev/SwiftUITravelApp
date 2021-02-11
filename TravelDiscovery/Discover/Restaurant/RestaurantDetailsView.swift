//
//  RestaurantDetailsView.swift
//  TravelDiscovery
//
//  Created by Владимир on 10.02.2021.
//

import SwiftUI

struct RestaurantDetails: Decodable {
    let description, country, city: String
    let popularDishes: [Dish]
    let photos: [String]
    let reviews: [Review]
}

struct Review: Decodable, Hashable {
    let user: ReviewUser
    let rating: Int
    let text: String
}

struct ReviewUser: Decodable, Hashable {
    let username, firstName, lastName, profileImage: String
}

struct Dish: Decodable, Hashable {
    let name, price, photo: String
    let numPhotos: Int
}

class RestaurantDetailsModel: ObservableObject {
    @Published var isLoading = true
    @Published var details: RestaurantDetails?
    
    init() {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/restaurant?id=0"
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
        
            DispatchQueue.main.async {
                do {
                    self.details = try JSONDecoder().decode(RestaurantDetails.self, from: data)
                }
                catch let jsonError {
                    print("unknow error: \(jsonError)")
                }
            }
        }.resume()
    }
}

struct RestaurantDetailsView: View {
    @ObservedObject var vm = RestaurantDetailsModel()
    
    let restaurant: Restaurant
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomLeading) {
                Image(restaurant.imageName)
                    .resizable()
                    .scaledToFill()
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurant.name)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack {
                            ForEach(0..<5, id: \.self) { num in
                                Image(systemName: "star.fill")
                            }.foregroundColor(.orange)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: RestaurantPhotosView(),
                        label: {
                            Text("See more photos")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular))
                                .frame(width: 80)
                                .multilineTextAlignment(.trailing)
                        })
                }.padding()
            }
            
            VStack(alignment: .leading) {
                Text("Location & Description")
                    .font(.system(size: 16, weight: .bold))

                Text("\(vm.details?.city ?? ""), \(vm.details?.country ?? "")")
                HStack {
                    ForEach(0 ..< 5, id: \.self) { item in
                        Image(systemName: "dollarsign.circle.fill")
                    }
                }.foregroundColor(.orange)

                HStack { Spacer() }
            }
            .padding(.top)
            .padding(.horizontal)
            
            Text(vm.details?.description ?? "")
                .font(.system(size: 14, weight: .regular))
                .padding(.top, 8)
                .padding(.bottom)
                .padding(.horizontal)
            
            HStack {
                Text("Popular Dishes")
                    .font(.system(size: 16, weight: .bold))
            }.padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.details?.popularDishes ?? [], id: \.self) { dish in
                        DishCell(dish: dish)
                    }
                }.padding(.horizontal)
            }
            
            if let reviews = vm.details?.reviews {
                ReviewsList(reviews: reviews)
            }
        }
        .navigationBarTitle("Restaurants Details", displayMode: .inline)
    }
}

struct ReviewsList: View {
    let reviews: [Review]
    
    var body: some View {
        HStack {
            Text("Customer Reviews")
                .font(.system(size: 16, weight: .bold))
        }.padding(.horizontal)

        ForEach(reviews, id: \.self) { review in
            VStack(alignment: .leading) {
                HStack {
                    KFImage(URL(string: review.user.profileImage))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(review.user.firstName) \(review.user.lastName)")
                            .font(.system(size: 14, weight: .bold))
                        
                        HStack(spacing: 4) {
                            ForEach(0..<review.rating, id: \.self) { item in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                            }
                            ForEach(0..<5 - review.rating, id: \.self) { item in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.gray)
                            }
                        }.font(.system(size: 12))
                    }
                    Spacer()
                    Text("Dec 2020")
                        .font(.system(size: 14, weight: .bold))
                }
                Text(review.text)
                    .font(.system(size: 14, weight: .regular))
            }
            .padding(.top)
            .padding(.horizontal)
        }
    }
}

import Kingfisher

struct DishCell: View {
    let dish: Dish
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                KFImage(URL(string: dish.photo))
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 4)
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                Text(dish.price).foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
            }
            .frame(height: 120)
            .cornerRadius(5)
            .padding(.horizontal, 8)
            .padding(.bottom, 4)
            
            Text(dish.name)
                .font(.system(size: 14, weight: .bold))
            Text("\(dish.numPhotos)").foregroundColor(.gray)
                .font(.system(size: 12, weight: .regular))
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailsView(restaurant: .init(name: "Japan's Restaurant", imageName: "tapas"))
    }
}
