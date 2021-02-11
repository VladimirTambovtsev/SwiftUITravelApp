//
//  PopularDestinationView.swift
//  TravelDiscovery
//
//  Created by Владимир on 09.02.2021.
//

import SwiftUI

struct PopularDestinationView: View {
    
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.855, longitude: 2.341),
        .init(name: "Tokyo", country: "Japan", imageName: "japan", latitude: 35.678, longitude: 139.76),
        .init(name: "New York", country: "USA", imageName: "new_york", latitude: 40.76, longitude: -74.0055),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Popular destinations")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(destinations, id: \.self) { destination in
                        NavigationLink(
                            destination: NavigationLazyView(PopularDestinationDetailsView(destination: destination)),
                            label: {
                                PopularDestinationTile(destination: destination)
                                    .padding(.bottom)
                            })
                    }
                }.padding(.horizontal)
            }
        }
    }
}


struct PopularDestinationTile: View {
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(4)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
            
            Text(destination.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(Color(.label))
            
            Text(destination.country)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
                .foregroundColor(.gray)
        }
            .asTile()
//            .modifier(TileModifier())
    }
}

import MapKit

struct Attraction: Identifiable {
    let id = UUID().uuidString
    let name, imageName: String
    let latitude, longitude : Double
}

struct DestinationDetails: Decodable {
    let description: String
    let photos: [String]
}

class DestinationDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetails?
    
    init(paramName: String) {
        let fixedUrlString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(paramName.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: fixedUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            DispatchQueue.main.async {
                guard let data = data else {return}
                do {
                    self.destinationDetails = try JSONDecoder().decode(DestinationDetails.self, from: data)
                } catch {
                    print("unknown error: ", error)
                }
            }
        }.resume()
    }
}

struct PopularDestinationDetailsView: View {
    let destination: Destination
    let imageUrlStrings: [String] = []
    
    @State var region: MKCoordinateRegion
    @State var showAttractions = true
    @ObservedObject var vm: DestinationDetailsViewModel
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "eiffel_tower", latitude: 48.859, longitude: 2.353),
        .init(name: "Louvre Museum", imageName: "new_york", latitude: 48.869, longitude: 2.343)
    ]
    
    init(destination: Destination) {
        self.destination = destination
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        self.vm = .init(paramName: destination.name)
    }
    
    var body: some View {
        ScrollView{
            if let photos = vm.destinationDetails?.photos {
                DestinationHeaderContainer(imageUrlStrings: vm.destinationDetails?.photos ?? [])
                    .frame(minWidth: 0, idealWidth: 500, maxWidth: .infinity, minHeight: 0, idealHeight: 300, maxHeight: .infinity, alignment: .leading)
            }
//            Image(destination.imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(minWidth: 0, idealWidth: 500, maxWidth: .infinity, minHeight: 0, idealHeight: 250, maxHeight: .infinity, alignment: .leading)
//                .clipped()
            
            VStack(alignment: .leading) {
                Text(destination.name)
                    .font(.system(size: 18, weight: .bold))
                Text(destination.country)
                HStack{
                    ForEach(0 ..< 5, id: \.self) { item in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }
                .padding(.top, 2)
                
                HStack {
                    Text(vm.destinationDetails?.description ?? "")
                        .padding(.top, 5)
                        .font(.system(size: 14))
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("Location")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                
                Button(action: { showAttractions.toggle() }, label: {
                    Text("\(showAttractions ? "Show" : "Hide") Attractions")
                        .font(.system(size: 12, weight: .semibold))
                })
                
                Toggle("", isOn: $showAttractions)
                    .labelsHidden()
            }.padding(.horizontal)
            
//            Map(coordinateRegion: $region)
            
            Map(coordinateRegion: $region, annotationItems: showAttractions ? attractions : []) { attraction in
//                MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude), tint: .red)
                MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude)) {
                    CustomMapAnnotation(attraction: attraction)
                }
            }.frame(height: 300)
            
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
}

struct CustomMapAnnotation: View {
    let attraction: Attraction
    
    var body: some View {
        VStack {
            Image(attraction.imageName)
                .resizable()
                .frame(width: 80, height: 60)
                .cornerRadius(4)

            Text(attraction.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(4)
//                .border(Color.black)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.init(white: 0, alpha: 0.5))))
        }.shadow(radius: 5)
    }
}

struct PopularDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        PopularDestinationView()
    }
}
