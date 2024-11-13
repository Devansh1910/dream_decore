import SwiftUI

struct ShowroomView: View {
    @State private var currentPage = 0
    @State private var selectedTab = 0 // Track the selected tab

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("bk_new")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView { // Make the entire screen scrollable
                    VStack(spacing: 20) {
                        
                        HStack {
                            HStack(spacing: 5) {
                                Image("showroomcircle") // Use your own custom icon here
                                    .resizable()
                                    .frame(width: 12, height: 12) // Adjust the icon size as needed
                                Text("Showroom")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.clear) // Set background to clear
                            .cornerRadius(10)
                            
                            Text("Dream")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Top Brands")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "#DBDBDB"))
                                .padding(.horizontal, 5)
                            
                            CustomCardView()
                                .frame(height: 250) // Adjust the height as needed
                                .padding(.horizontal)
                                .padding(.top, 20) // Added top padding of 20
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Explore")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "#DBDBDB"))
                                .padding(.horizontal, 10)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) { // Added spacing between rows
                                ForEach(1...4, id: \.self) { index in
                                    NavigationLink(
                                        destination: ItemInsiderView(
                                            imageName: "image\(index)",
                                            title: "Traditional Chair \(index)",
                                            brand: "Whiteteak",
                                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                                            price: "£200",
                                            originalPrice: "£499",
                                            discount: "75% Off"
                                        )
                                    ) {
                                        ItemUIView(imageName: "image\(index)", title: "Traditional Chair \(index)", brand: "Whiteteak", price: "$2,000")
                                    }
                                    .buttonStyle(PlainButtonStyle()) // Disable button highlight
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(hex: "#101010").cornerRadius(45))
                    .padding(.top, 70)
                }
                .navigationBarTitle("Dream Decor", displayMode: .inline)
                .navigationBarItems(
                    trailing: HStack {
                        Image(systemName: "magnifyingglass")
                        Image(systemName: "circle.fill")
                    }
                    .foregroundColor(.white)
                )
                
                // Bottom Navigation Bar with Middle Floating Button
                VStack {
                    Spacer()
                    
                    ZStack {
                        // Bottom Navigation Bar
                        HStack {
                            Spacer()
                            Button(action: { selectedTab = 0 }) {
                                VStack {
                                    Image("icon1") // Use your custom icon
                                        .resizable()
                                        .frame(width: 30, height: 30) // Adjust size as needed
                                    Text("Home")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(selectedTab == 0 ? .green : .gray)
                            }
                            Spacer()
                            Spacer() // Extra space for the middle icon
                            Spacer()
                            Button(action: { selectedTab = 2 }) {
                                VStack {
                                    Image("icon3") // Use your custom icon
                                        .resizable()
                                        .frame(width: 30, height: 30) // Adjust size as needed
                                    Text("Profile")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(selectedTab == 2 ? .green : .gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(35) // Increase corner radius to shape it like the image
                        .padding(.horizontal)
                        
                        // Middle Floating Button (above the bottom bar)
                        Button(action: { selectedTab = 1 }) {
                            VStack {
                                Image("iconmiddle") // Use your custom icon
                                    .resizable()
                                    .frame(width: 75, height: 75) // Slightly smaller than before for subtlety
                                    .background(Circle().fill(Color.black.opacity(0.8)))
                                    .clipShape(Circle())
                                Text("Favorites")
                                    .font(.system(size: 14, weight: .bold)) // Adjust font size for emphasis
                                    .foregroundColor(selectedTab == 1 ? .green : .gray)
                            }
                        }
                        .offset(y: -25) // Adjust to hover just above the bar
                    }
                    .padding(.bottom, 20) // Additional padding at the bottom
                }
            }
        }
    }
}

#Preview {
    ShowroomView()
}
