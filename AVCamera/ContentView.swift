//
//  ContentView.swift
//  AVCamera
//
//  Created by MANAS VIJAYWARGIYA on 03/11/22.
//

import SwiftUI

struct ContentView: View {
  @State private var capturedImage: UIImage? = nil
  @State private var isCustomCameraViewPresented = false
  
    var body: some View {
      ZStack {
        if capturedImage != nil {
          Image(uiImage: capturedImage!)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        } else {
          Color(UIColor.systemBackground)
        }
        
        VStack {
          Spacer()
          Button {
            isCustomCameraViewPresented.toggle()
          } label: {
            Image(systemName: "camera.fill")
              .font(.largeTitle)
              .padding()
              .background(Color.black)
              .foregroundColor(.white)
              .clipShape(Circle())
          }
          .padding(.bottom)
          .sheet(isPresented: $isCustomCameraViewPresented) {
            CustomCameraView(capturedImage: $capturedImage)
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
