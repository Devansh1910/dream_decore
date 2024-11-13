import SwiftUI

struct ItemUIView: View {
    var imageName: String
    var title: String
    var brand: String
    var price: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Main image with rounded corners
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 160)
                    .cornerRadius(15)
                    .clipped()
                
                // Star (favorite) icon in the top-right corner
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .background(Color.clear.clipShape(Circle()))
                    .padding(20)
            }
            
            // Text and details below the image
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1) // Limit title to 1 line
                    .truncationMode(.tail) // Show "..." if the text is too long
                
                Text(brand)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(price)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding([.leading, .bottom, .trailing], 8)
        }
        .background(Color.black.opacity(0.8))
        .cornerRadius(15) // Rounded corners for the entire card
        .shadow(radius: 5) // Soft shadow for a floating effect
    }
}

struct ItemUIView_Previews: PreviewProvider {
    static var previews: some View {
        ItemUIView(imageName: "image1", title: "Traditional Chair - Limited Edition with Special Design", brand: "Whiteteak", price: "$2,000")
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray)
    }
}
