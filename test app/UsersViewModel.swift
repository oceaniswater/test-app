import Foundation

final class UsersViewModel: ObservableObject {
    
    @Published var users: [User] = []
    
    func fetchUsers() {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        if let url = URL(string: urlString) {
            URLSession
                .shared
                .dataTask(with: url) {[weak self] data, response, error in
                    
                    DispatchQueue.main.async {
                        if let _ = error {
                            
                            // TODO: - handle error
                            
                        } else {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            
                            if let data = data,
                               let users = try? decoder.decode([User].self, from: data) {
                                
                                // TODO: - handle setting the data
                                
                                self?.users = users
                                
                                
                            } else {
                                
                                // TODO: - handle error
                                
                            }
                        }
                    }
                    
                    
                    
                }.resume()
        }
    }
}
