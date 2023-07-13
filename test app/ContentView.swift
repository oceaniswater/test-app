//
//  ContentView.swift
//  test app
//
//  Created by Mark Golubev on 13/07/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UsersViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.users, id: \.id) { user in
                        UserView(user: user)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            .navigationTitle("Users")
            }
            .onAppear(perform: viewModel.fetchUsers)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
