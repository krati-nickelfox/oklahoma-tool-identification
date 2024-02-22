//
//  ReportsSelectCategoryView.swift
//
//
//  Created by Chakshu Dawara on 22/02/24.
//

import SwiftUI

public struct ReportsSelectCategoryView: View {
    
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let placardImage: String
    let containerImage: String
    
    public init(
        placardImage: String,
        containerImage: String
    ) {
        self.placardImage = placardImage
        self.containerImage = containerImage
    }
    
    // MARK: Body
    public var body: some View {
        ZStack {
            VStack(spacing: 40) {
                HeaderView(title: "View Reports", leftButtonAction: {
                    presentationMode.wrappedValue.dismiss()
                }, rightButtonAction: nil, leftIconName: "", rightIconName: nil)
                selectCategoryTitleView
                categoriesView
                Spacer()
            }
        }
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
    }
    
    var selectCategoryTitleView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Select Category")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Please select any one of the following:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            })
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var categoriesView: some View {
        VStack(spacing: 20, content: {
            ForEach(0..<2) { _ in
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 8)
                    
                    HStack(alignment: .center, spacing: 16, content: {
                        
                        Image("Cooper Credit")
                            .resizable()
                            .frame(width: 48, height: 48)
                        
                        Text("Placards")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4, content: {
                            HStack(spacing: 0, content: {
                                Text("Score: ")
                                    .foregroundColor(.gray)
                                
                                Text("0.5%")
                                    .foregroundColor(.red)
                            })
                            
                            ProgressView(value: 0.5)
                                .progressViewStyle(LinearProgressViewStyle())
                                .tint(.red)
                                .background(.black)
                                .cornerRadius(3.0)
                        })
                        .frame(width: 120)
                    })
                    .padding(.horizontal, 20)
                }
                .frame(height: 72)
                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
            }
        })
        .padding(.horizontal, 18)
    }
}
