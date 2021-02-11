//
//  ActivityIndicatorView.swift
//  TravelDiscovery
//
//  Created by Владимир on 09.02.2021.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .white
        return aiv
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
    
    typealias UIViewType = UIActivityIndicatorView
}



struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
