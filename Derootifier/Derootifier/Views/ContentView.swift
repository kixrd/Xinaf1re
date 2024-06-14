//
//  ContentView.swift
//  Xinaf1re
//
//  Updated by Sudo on 6/13/2024
//

import SwiftUI
import FluidGradient

struct ContentView: View {
    let scriptPath = Bundle.main.path(forResource: "Xinam1nePatcher", ofType: "sh")!
    @AppStorage("firstLaunch") private var firstLaunch = true
    @State private var showingSheet = false
    @State private var selectedFile: URL?
    @State private var outputAux = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Xinaf1re")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                Button("Select .deb file") {
                    showingSheet.toggle()
                }
                .buttonStyle(TintedButton(color: .white, fullwidth: true))
                
                if let selectedFile = selectedFile {
                    Button("Convert .deb") {
                        UIApplication.shared.alert(title: "Converting...", body: "Please wait", withButton: false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            outputAux = repackDeb(scriptPath: scriptPath, debURL: selectedFile)
                            UIApplication.shared.dismissAlert(animated: false)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                UIApplication.shared.confirmAlert(title: "Done", body: outputAux, onOK: {
                                    checkFileMngrs()
                                }, noCancel: false)
                            }
                        }
                    }
                    .buttonStyle(TintedButton(color: .white, fullwidth: true))
                }
                
                NavigationLink(
                    destination: CreditsView(),
                    label: {
                        HStack {
                            Text("Credits")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 15))
                    }
                )
                .padding()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background (
                FluidGradient(blobs: [.orange, .black],
                              highlights: [.orange, .black],
                              speed: 0.5,
                              blur: 0.80)
                .background(.orange)
            )
            .ignoresSafeArea()
            .onAppear {
                if firstLaunch {
                    UIApplication.shared.alert(title: "Warning", body: "Please make sure the following packages are installed: dpkg, gawk, file, plutil, odcctools, ldid (from Procursus).")
                    firstLaunch = false
                }
#if !targetEnvironment(simulator)
                folderCheck()
#endif
            }
            .sheet(isPresented: $showingSheet) {
                DocumentPicker(selectedFile: $selectedFile)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
