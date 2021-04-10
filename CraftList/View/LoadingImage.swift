//
//  LoadingImage.swift
//  CraftList
//
//  Created by Lizz Clark on 10/04/2021.
//

import UIKit
import SwiftUI
import Combine

struct LoadingImage: View {
    @State var image: Image = Image(systemName: "cloud.sun")
    
    private let publisher: AnyPublisher<UIImage, Never>
    
    init(publisher: AnyPublisher<UIImage, Never>) {
        self.publisher = publisher
    }
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .onReceive(publisher, perform: { uiImage in
                image = Image(uiImage: uiImage)
            })
    }
}
