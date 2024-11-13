import SwiftUI

struct CustomCardView: View {
    var body: some View {
        ZStack {
            // Main container
            Color.clear
                .frame(width: 200, height: 200)
                .cornerRadius(20)
                .shadow(radius: 10)
            
            // Main cover image in the center
            Image("image1")
                .resizable()
                .frame(width: 210, height: 210)
                .cornerRadius(20)
                .shadow(radius: 10, x: 10, y: 10)

            
            // Secondary image in the top-right corner
            Image("image2")
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(10)
                .shadow(radius: 10, x: 10, y: 10)
                .position(x: 250, y: 25) // Position to top-right corner

            // Third image in the bottom-left corner
            Image("image3")
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(5)
                .shadow(radius: 10, x: 10, y: 10)
                .position(x: 80, y: 200) // Position to bottom-left corner

            // Fourth image in the top-left corner
            Image("image4")
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(5)
                .shadow(radius: 10, x: 10, y: 10)
                .position(x: 80, y: 25) // Position to top-left corner
        }
    }
}

#Preview {
    CustomCardView()
}
