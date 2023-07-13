import SwiftUI

struct UserView: View {
    
    let user: User
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(user.name)")
            Text("Email: \(user.email)")
            Divider()
            Text("Company: \(user.company.name)")
        }
        .frame(minWidth: .zero, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 4)
        
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: .init(id: 0, name: "Mark Golubev", username: "oceaniswater", email: "piskasosiska@gmail.com", company: .init(name: "Apple")))
    }
}
