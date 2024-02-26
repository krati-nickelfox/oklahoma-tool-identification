//
//  PrimaryGrayBorderedView.swift
//
//
//  Created by Krati Mittal on 19/02/24.
//

import SwiftUI

struct PrimaryGrayBorderedView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(LinearGradient(
                gradient: Gradient(colors: [.white,
                                            .clear]),
                startPoint: .top,
                endPoint: .bottomTrailing
            ), lineWidth: 1.0)
            .shadow(color: .white.opacity(0.08), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 4)
    }
}

#Preview {
    PrimaryGrayBorderedView()
}
