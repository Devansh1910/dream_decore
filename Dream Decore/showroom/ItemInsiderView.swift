import SwiftUI

struct ItemInsiderView: View {
    var imageName: String
    var title: String
    var brand: String
    var description: String
    var price: String
    var originalPrice: String
    var discount: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isARPresented = false // Track AR presentation
    @State private var resetAR = false // Track reset state for AR view
    @State private var modelScale: Float = 0.5 // Set the initial model scale

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Main product image with AR View button
                ZStack(alignment: .bottomTrailing) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(20)
                    
                    NavigationLink(
                        destination: ARViewContainer(modelName: "sample", reset: $resetAR,initialScale: modelScale),
                        isActive: $isARPresented
                    ) {
                        HStack {
                            Image(systemName: "arkit")
                            Text("View AR")
                        }
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(20)
                    }
                }
                
                // Product details...
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(brand)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .truncationMode(.tail)
                    
                    // Pricing section in horizontal layout...
                    HStack(spacing: 10) {
                        Text(price)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Text(originalPrice)
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundColor(.gray)
                        
                        Text(discount)
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    
                    // Make it yours button
                    Button(action: {
                        // Make it yours action
                    }) {
                        Text("Make it yours")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(10)
                .background(Color.black.opacity(0.8))
                .cornerRadius(15)
                
                // Reviews and similar products...
                VStack(alignment: .leading, spacing: 20) {
                    Text("Reviews")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(0..<2) { _ in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("James Advort")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text("I was amazed by how sleek and contemporary the design turned out.")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                    }
                    
                    Text("Similar Products")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(1...3, id: \.self) { index in
                                ItemUIView(imageName: "image\(index)", title: "Product \(index)", brand: "Brand", price: "$1,200")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarTitle(title, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ItemInsiderView(
        imageName: "image1",
        title: "Classic Chair",
        brand: "Whiteteak Decors",
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
        price: "£200",
        originalPrice: "£499",
        discount: "75% Off"
    )
}
