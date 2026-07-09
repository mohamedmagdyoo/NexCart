import SwiftUI

struct UpdateProfileView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
            }
            
            Button("Save Changes") {
                // Save logic here
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundColor(AppColor.gold)
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
