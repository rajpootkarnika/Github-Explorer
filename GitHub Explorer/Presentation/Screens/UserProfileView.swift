//
//  UserProfileView.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import SwiftUI

struct UserProfileView: View {
    let username: String

    var body: some View {
        Text("User: \(username)")
            .navigationTitle("Profile")
    }
}
