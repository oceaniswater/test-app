import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UsersViewModel()
    @State private var hasError = false
    @State private var error: UsersViewModel.UserError?
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isRefreshing {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.users, id: \.id) { user in
                            UserView(user: user)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Users")
                }
            }
//            .onAppear(perform: viewModel.fetchUsersCombine)
            .task {
                await execute()
            }
//            .alert(isPresented: $viewModel.hasError, error: viewModel.error)
            .alert(isPresented: self.$hasError, error: self.error) {
//                Button(action: viewModel.fetchUsersCombine) {
//                    Text("Retry")
//                }
                Button {
                    Task {
                        await execute()
                    }
                } label: {
                    Text("Retry")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private extension ContentView {
    func execute() async {
        do {
            try await viewModel.fetchUsersAsyncAwait()
        } catch {
            if let usrErr = error as? UsersViewModel.UserError {
                self.hasError = true
                self.error = usrErr
            }
        }
    }
}
