//
//  CreditsView.swift
//  Xinaf1re
//
//  Updated by Sudo on 6/13/2024
//

import SwiftUI
import FluidGradient

struct CreditsView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                FluidGradient(blobs: [.orange, .black],
                              highlights: [.orange, .black],
                              speed: 0.5,
                              blur: 0.80)
                .background(.orange)
                .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        creditView(imageURL: URL(string: "https://avatars.githubusercontent.com/u/91740362?v=4"), name: "sudo9000", description: "Developer, Original Xinam1ne dev. Updated app & UI")
                        creditView(imageURL: URL(string: "https://avatars.githubusercontent.com/u/113779460?v=4"), name: "talhah58", description: "Developer, Updated Xinam1ne patcher for app use")
                        creditView(imageURL: URL(string: "https://avatars.githubusercontent.com/u/81449663?v=4"), name: "NightwindDev", description: "Tester")
                        creditView(imageURL: URL(string: "https://avatars.githubusercontent.com/u/80824905?v=4"), name: "korboybeats", description: "Tester")
                    }
                    .padding()
                }
                .padding()
                .listStyle(.insetGrouped)
            }
        }
    }
    
    private func creditView(imageURL: URL?, name: String, description: String) -> some View {
        HStack {
            AsyncImage(url: imageURL, content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 35, maxHeight: 35)
                    .cornerRadius(20)
            }, placeholder: {
                ProgressView()
                    .frame(maxWidth: 35, maxHeight: 35)
            })
            
            VStack(alignment: .leading) {
                Button(name) {
                    if let url = URL(string: "https://github.com/\(name)") {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .foregroundColor(.white)
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}
