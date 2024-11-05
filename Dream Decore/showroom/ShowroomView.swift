import SwiftUI

struct ShowroomView: View {
    var body: some View {
        ZStack {
            // Background image
            Image("background_image")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                // Header with toggle for "Showroom" and "Dream"
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "house.fill")
                            .foregroundColor(.white)
                        Text("Showroom")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .cornerRadius(10)
                    
                    Text("Dream")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                
                // Top Brands Section
                VStack(alignment: .leading) {
                    Text("Top Brands")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#DBDBDB"))
                        .padding(.horizontal, 5)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(1..<4) { index in
                                Image("brand\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                
                // "Bring your Dreams to Reality" Banner with Image Background
                ZStack {
                    // Background image with rounded corners
                    Image("background_of_house") // Replace with the actual image name
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100) // Adjusted height to fit content
                        .cornerRadius(10)
                        .clipped() // Ensures the image respects the corner radius
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Bring your Dreams to Reality")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
                            Text("Get a classy description here.")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.black.opacity(0.7))
                            
                            // "Explore" link at the bottom left
                            Text("Explore >")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(Color(hex:"#3B3B3B"))
                                .padding(.top, 5)
                        }
                        .padding(.leading, 5)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }

                
                // Explore Section
                VStack(alignment: .leading) {
                    Text("Explore")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#DBDBDB"))
                        .padding(.horizontal, 5)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(1..<5) { index in
                                Image("explore\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color(hex: "#101010").opacity(0.9).cornerRadius(45))
            .padding(.top, 40)
            .navigationBarTitle("Dream Decor", displayMode: .inline)
            .navigationBarItems(
                trailing: HStack {
                    Image(systemName: "magnifyingglass")
                    Image(systemName: "circle.fill")
                }
                .foregroundColor(.white)
            )
        }
    }
}

#Preview {
    ShowroomView()
}
