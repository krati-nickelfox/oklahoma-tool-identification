//
//  File.swift
//  
//
//  Created by Krati Mittal on 15/02/24.
//

import SwiftUI

struct OptionView: View {
    
    var (option, optionState): (Option, Optionstate)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(self.optionState.color)
            .frame(minHeight: 48)
            .overlay {
                HStack(spacing: 10) {
                    Text(option.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Spacer()

                    if self.optionState != .none {
                        Circle()
                            .fill(self.optionState.color.opacity(0.4))
                            .frame(width: 24, height: 24)
                            .overlay {
                                Image(self.optionState.image,
                                      bundle: .module)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(5)
                            }
                    }
                }
                .frame(alignment: .leading)
                .foregroundStyle(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [.white, .gray.opacity(0.6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ), lineWidth: 0.75)
            }
            .padding(.horizontal, 1)
            .shadow(color: .white.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}
