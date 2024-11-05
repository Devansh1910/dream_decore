import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var passwordErrorMessage = ""
    @State private var isLoginButtonDisabled = true
    @State private var isPresentingSignup = false // State variable to control modal presentation

    var body: some View {
        ZStack {
            // Background image
            Image("background_image") // Replace with the name of your image
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Content with black rounded background
            VStack(spacing: 20) {
                Spacer()

                // Title
                Text("Login Your Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Email field with icon and placeholder
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        Text("Enter your email")
                            .foregroundColor(.gray)
                            .padding(.leading, 40)
                    }
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("", text: $email)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .onChange(of: email) { _ in
                                validateEmailAndPassword()
                            }
                    }
                    .padding(.leading, 10)
                    .padding(.vertical, 15)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                // Password field with icon, placeholder, and visibility toggle
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text("Enter your password")
                            .foregroundColor(.gray)
                            .padding(.leading, 35)
                    }
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if isPasswordVisible {
                            TextField("", text: $password)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .onChange(of: password) { _ in
                                    validateEmailAndPassword()
                                }
                        } else {
                            SecureField("", text: $password)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .onChange(of: password) { _ in
                                    validateEmailAndPassword()
                                }
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.vertical, 15)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                // Error message for password validation
                if !passwordErrorMessage.isEmpty {
                    Text(passwordErrorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                // Forgot Password
                HStack {
                    Spacer()
                    Button(action: {
                        // Action for forgot password
                    }) {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                // Login button with gradient background
                Button(action: {
                    // Action for login
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(10)
                }
                .disabled(isLoginButtonDisabled)
                .padding(.horizontal)

                // Create New Account
                HStack {
                    Text("Create New Account?")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        withAnimation {
                            isPresentingSignup = true // Trigger the modal presentation with animation
                        }
                    }) {
                        Text("Sign up")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 10)

                // Divider
                Divider().background(Color.gray)

                // Social login options
                Text("Continue With Accounts")
                    .foregroundColor(.gray)
                    .padding(.top)

                HStack(spacing: 15) {
                    Button(action: {
                        // Facebook login action
                    }) {
                        Image("Facebook (Button)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 50)
                    }

                    Button(action: {
                        // Google login action
                    }) {
                        Image("Google (Button)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 50)
                    }

                    Button(action: {
                        // Apple login action
                    }) {
                        Image("Apple (Button)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 50)
                    }
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .background(Color(hex: "#101010"))
            .cornerRadius(45)
            .padding(.top, 25) // Adds padding to the sides to allow background to be visible
            
            // Conditionally display SignupView with fade-in effect
            if isPresentingSignup {
                SignupView()
                    .transition(.opacity) // Apply fade transition
                    .animation(.easeInOut) // Control animation timing
            }
        }
    }

    // Password validation function
    func validatePassword() -> Bool {
        let uppercaseLetter = CharacterSet.uppercaseLetters
        let lowercaseLetter = CharacterSet.lowercaseLetters
        let number = CharacterSet.decimalDigits
        let specialCharacter = CharacterSet.punctuationCharacters.union(.symbols)
        
        if password.count < 8 || password.count > 16 {
            passwordErrorMessage = "Password must be between 8 and 16 characters."
            return false
        } else if password.rangeOfCharacter(from: uppercaseLetter) == nil {
            passwordErrorMessage = "Password must include at least one uppercase letter."
            return false
        } else if password.rangeOfCharacter(from: lowercaseLetter) == nil {
            passwordErrorMessage = "Password must include at least one lowercase letter."
            return false
        } else if password.rangeOfCharacter(from: number) == nil {
            passwordErrorMessage = "Password must include at least one number."
            return false
        } else if password.rangeOfCharacter(from: specialCharacter) == nil {
            passwordErrorMessage = "Password must include at least one special character."
            return false
        } else {
            passwordErrorMessage = ""
            return true
        }
    }

    // Email validation function
    func validateEmail() -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }

    // Function to validate both email and password
    func validateEmailAndPassword() {
        if validateEmail() && validatePassword() {
            isLoginButtonDisabled = false
        } else {
            isLoginButtonDisabled = true
        }
    }
}

#Preview {
    LoginView()
}
