//
//  ReportsView.swift
//
//
//  Created by Chakshu Dawara on 22/02/24.
//

import SwiftUI

public struct ReportsView: View {
    
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    public init() { }
    
    // MARK: Body
    public var body: some View {
        ZStack {
            VStack {
                HeaderView(title: "Placards Reports", leftButtonAction: {
                    presentationMode.wrappedValue.dismiss()
                }, rightButtonAction: {}, leftIconName: "back-icon", rightIconName: "ExitIcon")
                subcategoriesProgressView
            }
        }
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
    }
    
    var subcategoriesProgressView: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(spacing: 16, content: {
                ForEach(0..<10) { num in
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 1)
                        
                        HStack(spacing: 16) {
                            Text("Subcategory\(num)")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Text("80.0%")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            ProgressView(value: 0.5)
                                .progressViewStyle(LinearProgressViewStyle())
                                .frame(height: 10)
                                .scaleEffect(x: 1, y: 2.5, anchor: .center)
                                .tint(.red)
                        }
                        .padding(.horizontal, 16)
                    }
                    .background(LinearGradient(colors: [Color(red: 27/255, green: 24/255, blue: 25/255), Color(red: 35/255, green: 31/255, blue: 32/255)], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 31)
                }
            })
            .padding(.horizontal, 12)
        })
    }
    
    // Progress bar tint color as per the percentage
    /// 0 - 49.9% Red
    /// 50 - 69.9% Yellow
    /// 70 - 100% Green
    func progressTintColor(for score: Double) -> Color {
        switch score {
        case 0..<50:
            return .red
        case 50..<70:
            return .yellow
        default:
            return .green
        }
    }
}
