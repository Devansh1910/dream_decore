import SwiftUI

struct CustomBottomNavBarUIView: View {
    var body: some View {
        HStack(spacing: 30) {
            // Custom Button 1
            Button(action: {
                // Action for Button 1
            }) {
                VStack {
                    Image("icon1") // Replace "icon1" with the image name in Assets
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Home")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            
            // Custom Button 2
            Button(action: {
                // Action for Button 2
            }) {
                VStack {
                    Image("iconmiddle") // Replace "icon2" with the image name in Assets
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Explore")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            
            // Custom Button 3
            Button(action: {
                // Action for Button 3
            }) {
                VStack {
                    Image("icon3") // Replace "icon3" with the image name in Assets
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Favorites")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "#000000").opacity(0.9))
        .cornerRadius(20)
        .padding(.bottom, 10)
        .shadow(radius: 5)
    }
}
