import SwiftUI

struct ShowroomView: View {
    var body: some View {
        ZStack {
            // Background color
            Image("background_image") // Replace with your background image name
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                // Header with toggle for "Showroom" and "Dream"
                HStack {
                    Text("Showroom")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
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
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(1..<4) { index in
                                Image("brand\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Whiteteak")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                
                // "Bring your Dreams to Reality" Banner
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.green)
                        .frame(height: 100)
                    
                    VStack {
                        Text("Bring your Dreams to Reality")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Get a classy description here.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("Explore >")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                // Explore Section
                VStack(alignment: .leading) {
                    Text("Explore")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
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
            .background(Color(hex: "#101010").cornerRadius(45))
            .padding(.top, 25)
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
