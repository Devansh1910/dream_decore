import SwiftUI
import Firebase

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to manage presentation mode
    @State private var name = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var phoneNumberErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @State private var registrationErrorMessage = ""
    @State private var isLoading = false // State variable for showing loader

    var body: some View {
        ZStack {
            // Background image
            Image("background_image") // Replace with your background image name
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Content with black rounded background
            VStack(spacing: 20) {
                // Back button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back to previous view
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 10)

                Spacer()

                // Title
                Text("Create your Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Name field
                createTextField(placeholder: "Name", text: $name, image: "person")
                
                // Email field
                createTextField(placeholder: "Email", text: $email, image: "envelope", keyboardType: .emailAddress, textInputAutocapitalization: .never)

                // Phone number field
                createTextField(placeholder: "Phone", text: $phoneNumber, image: "phone", keyboardType: .phonePad, validate: validatePhoneNumber, errorMessage: $phoneNumberErrorMessage)
                
                // Password field
                createPasswordField()
                
                // Registration button with gradient background
                Button(action: {
                    if validatePhoneNumber() && validatePassword() {
                        isLoading = true // Show loading indicator
                        registerUser()
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    } else {
                        Text("Register")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(10)
                    }
                }
                .disabled(isLoading) // Disable button while loading
                .padding(.horizontal)

                // Display registration error message if any
                if !registrationErrorMessage.isEmpty {
                    Text(registrationErrorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 5)
                }

                // Sign In Link
                HStack {
                    Text("Already Have An Account?")
                        .foregroundColor(.gray)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back to login screen
                    }) {
                        Text("Sign In")
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
            .padding(.top, 25)
        }
    }

    private func createTextField(
        placeholder: String,
        text: Binding<String>,
        image: String,
        keyboardType: UIKeyboardType = .default,
        textInputAutocapitalization: TextInputAutocapitalization = .sentences, // New parameter
        validate: (() -> Bool)? = nil,
        errorMessage: Binding<String>? = nil
    ) -> some View {
        ZStack(alignment: .leading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 40)
            }
            HStack {
                Image(systemName: image)
                    .foregroundColor(.gray)
                TextField("", text: text)
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(textInputAutocapitalization) // Apply autocapitalization setting
                    .onChange(of: text.wrappedValue) { _ in
                        validate?()
                    }
            }
            .padding(.leading, 10)
            .padding(.vertical, 15)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .overlay(
            errorMessage?.wrappedValue.isEmpty == false ? Text(errorMessage?.wrappedValue ?? "")
                .foregroundColor(.red)
                .font(.caption)
                .padding(.top, 5) : nil,
            alignment: .bottom
        )
    }


    private func createPasswordField() -> some View {
        ZStack(alignment: .leading) {
            if password.isEmpty {
                Text("Password")
                    .foregroundColor(.gray)
                    .padding(.leading, 40)
            }
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                if isPasswordVisible {
                    TextField("", text: $password)
                        .foregroundColor(.white)
                } else {
                    SecureField("", text: $password)
                        .foregroundColor(.white)
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
    }

    private func registerUser() {
        isLoading = true
        print("Starting registration process...")
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Authentication error: \(error.localizedDescription)")
                registrationErrorMessage = "Registration failed: \(error.localizedDescription)"
                isLoading = false
                return
            }
            
            guard let user = authResult?.user else {
                print("Error: User could not be created.")
                registrationErrorMessage = "Unexpected error: User could not be created."
                isLoading = false
                return
            }
            
            let userId = user.uid
            let userData: [String: Any] = [
                "Name": name,
                "Email": email,
                "PhoneNumber": phoneNumber,
                "docId": userId
            ]
            
            Firestore.firestore().collection("users").document(userId).setData(userData) { error in
                isLoading = false
                if let error = error {
                    print("Firestore save error: \(error.localizedDescription)")
                    registrationErrorMessage = "Failed to save user data: \(error.localizedDescription)"
                } else {
                    print("User registered and data saved to Firestore successfully.")
                    registrationErrorMessage = ""
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }



    private func validatePhoneNumber() -> Bool {
        if phoneNumber.count < 10 || phoneNumber.count > 16 {
            phoneNumberErrorMessage = "Phone number must be between 10 and 16 characters."
            return false
        } else {
            phoneNumberErrorMessage = ""
            return true
        }
    }

    private func validatePassword() -> Bool {
        let passwordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=]).{8,12}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        
        if !passwordPredicate.evaluate(with: password) {
            passwordErrorMessage = "Password must be 8-12 characters long, include 1 capital letter, 1 lowercase letter, 1 number, and 1 special character."
            return false
        } else {
            passwordErrorMessage = ""
            return true
        }
    }
}

#Preview {
    SignupView()
}
