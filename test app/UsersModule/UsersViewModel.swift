import Foundation
import Combine

final class UsersViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var hasError = false
    @Published var error: UserError?
    @Published private(set) var isRefreshing = false
    private var bag = Set<AnyCancellable>()
    
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
    
    func fetchUsersCombine() {
        
        let urlString = "https://jsonplaceholder.typicode.com/users"
        if let url = URL(string: urlString) {
            
            isRefreshing = true
            hasError = false
            
            URLSession
                .shared
                .dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap({ result in
                    guard let response = result.response as? HTTPURLResponse,
                          response.statusCode >= 200 && response.statusCode < 300 else {
                        throw UserError.invalidStatusCode
                    }
                    
                    let decoder = JSONDecoder()
                    guard let users = try? decoder.decode([User].self, from: result.data) else {
                        throw UserError.failedToDecode
                    }
                    return users
                })
                .sink { [weak self] result in
                    defer { self?.isRefreshing = false }
                    
                    switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.hasError = true
                        self?.error = UserError.custom(error: error)
                    }
                    
                } receiveValue: { [weak self] users in
                    self?.users = users
                }
                .store(in: &bag)
        }
        
    }
    
    @MainActor
    func fetchUsersAsyncAwait() async throws {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        if let url = URL(string: urlString) {
            isRefreshing = true
            defer { isRefreshing = false }
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw UserError.invalidStatusCode
                }
                
                let decoder = JSONDecoder()
                guard let users = try? decoder.decode([User].self, from: data) else {
                    throw UserError.failedToDecode
                }
                
                self.users = users
            } catch {
                throw UserError.custom(error: error)
            }
        }
    }
}

extension UsersViewModel {
    enum UserError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case invalidStatusCode
        
        var errorDescription: String? {
            switch self {
            case .custom(error: let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Failed to decode response"
            case .invalidStatusCode:
                return "Invalid status code"
            }
        }
    }
}
