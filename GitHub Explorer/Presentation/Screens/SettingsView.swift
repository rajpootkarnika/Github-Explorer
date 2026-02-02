//
//  SettingsView.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var token = KeychainStore.load() ?? ""
    @State private var bannerMessage: String?
    @State private var bannerColor: Color = .green

    var body: some View {
        Form {
            Section {
                SecureField("GitHub Token", text: $token)
            }

            Button("Save") {
                KeychainStore.save(token: token)
                showBanner(
                    message: "Token saved successfully",
                    color: .green
                )
            }

            Button("Remove Token", role: .destructive) {
                KeychainStore.delete()
                token = ""
                showBanner(
                    message: "Token removed successfully",
                    color: .red
                )
            }
        }
        .navigationTitle("Settings")
        .overlay(alignment: .top) {
            if let message = bannerMessage {
                bannerView(message)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: bannerMessage)
    }

    // MARK: - Helpers
    private func showBanner(message: String, color: Color) {
        bannerMessage = message
        bannerColor = color

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            bannerMessage = nil
        }
    }

    private func bannerView(_ message: String) -> some View {
        Text(message)
            .font(.subheadline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(bannerColor.opacity(0.9))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
    }
}
