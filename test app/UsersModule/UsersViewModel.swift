import Foundation

final class UsersViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var hasError = false
    @Published var error: UserError?
    @Published private(set) var isRefreshing = false
    
    func fetchUsers() {
        
        isRefreshing = true
        hasError = false
        
        let urlString = "https://jsonplaceholder.typicode.com/users"
        if let url = URL(string: urlString) {
            URLSession
                .shared
                .dataTask(with: url) {[weak self] data, response, error in
                    
                    DispatchQueue.main.async {
                        if let error = error {
                            
                            // TODO: - handle error
                            self?.hasError = true
                            self?.error = UserError.custom(error: error)
                            
                        } else {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            
                            if let data = data,
                               let users = try? decoder.decode([User].self, from: data) {
                                
                                // TODO: - handle setting the data
                                
                                self?.users = users
                            } else {
                                
                                // TODO: - handle error
                                self?.hasError = true
                                self?.error = UserError.failedToDecode
                            }
                        }
                        self?.isRefreshing = false
                    }
                    
                    
                    
                }.resume()
        }
    }
}

extension UsersViewModel {
    enum UserError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        
        var errorDescription: String? {
            switch self {
            case .custom(error: let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Failed to decode response"
            }
        }
    }
}
