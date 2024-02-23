//
//  GradientDividerView.swift
//
//
//  Created by Krati Mittal on 19/02/24.
//

import SwiftUI

struct GradientDividerView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.init(red: 0.321, green: 0.321, blue: 0.321),
                                        .clear]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(height: 1)
    }
}

#Preview {
    GradientDividerView()
}
