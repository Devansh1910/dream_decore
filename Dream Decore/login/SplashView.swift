import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            // Background View: LoginView
            ShowroomView()
                .opacity(isActive ? 1 : 0) // LoginView appears instantly when isActive is true
            
            // Foreground View: SplashView
            VStack {
                Spacer()
                
                Image("splashlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Spacer()
                
                Text("Dream Decor")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 18 / 255, green: 21 / 255, blue: 29 / 255)) // Background color
            .opacity(isActive ? 0 : 1) // Hide splash screen instantly when transitioning
            .onAppear {
                // Delay for 3 seconds before switching to the LoginView
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isActive = true
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    SplashView()
}
