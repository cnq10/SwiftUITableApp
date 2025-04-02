//
//  ContentView.swift
//  TableSwiftUI
//
//  Created by Olivia Korte on 4/1/25.
//

import SwiftUI
import MapKit


let data = [
    Item(name: "Flowers Hall", neighborhood: "Texas State University Campus", desc: "A historic campus building with quiet study areas and nearby greenspaces.", lat: 29.889057106627064, long: -97.94024557510834, imageName: "flowershall"),
    Item(name: "Albert B. Alkek Library", neighborhood: "Texas State University Campus", desc: "A multi-level library packed with study nooks and creative spaces.", lat: 29.889664752388345, long: -97.94289662026559, imageName: "alkek"),
    Item(name: "New Braunfels Coffee", neighborhood: "489 Main Plaza, New Braunfels, TX 78130", desc: "A cozy coffee shop that is perfect for getting work done!", lat: 29.70377900090141, long: -98.12471149768001, imageName: "nbcafe"),
    Item(name: "San Marcos River", neighborhood: "650 River Rd, San Marcos, TX 78666", desc: "Discover a outdoor escape with shaded areas perfect for working outdoors!", lat: 29.91326623826592, long: -97.93792334153291, imageName: "park"),
    Item(name: "How to Find the Right Spot", neighborhood: "your home", desc: "Find your ideal work spot at home or in your backyard!", lat: 0, long: 0, imageName: "korte.backyard")
]


struct Item: Identifiable {
    let id = UUID()  // This makes it Identifiable
    let name: String
    let neighborhood: String
    let desc: String
    let lat: Double
    let long: Double
    let imageName: String
}


struct DetailView: View {
    @State private var position: MapCameraPosition
    let item: Item

    init(item: Item) {
        self.item = item
        _position = State(initialValue: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long),
            span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        )))
    }

    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200)

            Text("Neighborhood: \(item.neighborhood)")
                .font(.subheadline)

            Text("Description: \(item.desc)")
                .font(.subheadline)
                .padding(10)

            Map(position: $position) {
                Annotation(item.name, coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text(item.name)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
            }
            .frame(height: 300)
            .padding(.bottom, -30)

            Spacer()
        }
        .navigationTitle(item.name)
    }
}
 



struct ContentView: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 29.91326623826592, longitude: -97.93792334153291),
            span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        )
    )
    @State private var searchText = ""  // Filter criteria (search text)
    
    // Filter data based on the search text
    var filteredData: [Item] {
        if searchText.isEmpty {
            return data  // No filter applied, return all items
        } else {
            return data.filter { $0.neighborhood.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search by Neighborhood", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                List(filteredData, id: \.id) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.neighborhood)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                
                Map(position: $position) {
                    ForEach(filteredData) { item in
                        Annotation(item.name, coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                                Text(item.name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }
                    }
                }
                .frame(height: 300)
                .padding(.bottom, -30)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Freelance Nook")
        }
    }
}

       

#Preview {
    ContentView()
}
