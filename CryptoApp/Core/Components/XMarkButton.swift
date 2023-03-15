//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by Nazar Prysiazhnyi on 08.03.2023.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) private var dismiss
   
    var body: some View {
        Button(action: dismiss.callAsFunction,
               label: { Image(systemName: "xmark").font(.headline) }
        )
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton().previewLayout(.sizeThatFits)
    }
}
