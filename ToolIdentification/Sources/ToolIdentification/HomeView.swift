//  HomeView.swift
//  OklahomaToolIdentification
//
//  Created by Krati Mittal on 11/01/24.
//

import SwiftUI

struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

public struct HomeView: View {
    
    let primaryGradientColor = Color(red: 0.137,
                                     green: 0.121,
                                     blue: 0.125)
    public init() {}
    
    public var body: some View {
        ZStack {
            /// Background Image view
            Image("HomeIcon") // Fixme: Required to be configured
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            LinearGradient(colors: [primaryGradientColor.opacity(0.82),
                                    primaryGradientColor.opacity(0.74),
                                    primaryGradientColor.opacity(0.68),
                                    primaryGradientColor.opacity(0.48),
                                    primaryGradientColor.opacity(0.41),
                                    primaryGradientColor.opacity(0)],
                           startPoint: .top,
                           endPoint: .bottom)
            
            VStack {
                VStack(spacing: 65) {
                    /// App specific logo icon with edition details
                    Image("IFSTAIcon") // Fixme: Required to be configured
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.5 * ScreenSize.width)
                    
                    VStack(spacing: 20) {
                        Text("Identify")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(height: 50)
                        
                        Capsule()
                            .frame(width: 55, height: 7)
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 65) {
                    VStack(spacing: 28) {
                        Text("Container Identification")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("Remaining Questions :  157/ 157")
                            .fontWeight(.regular)
                            .foregroundStyle(.white)
                    }
                    
                    VStack(spacing: 30) {
                        Button(action: {
                            
                        }, label: {
                            Text("Let’s Begin")
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .frame(width: 0.5 * ScreenSize.width, height: 0.06 * ScreenSize.height)
                                .background(.yellow)
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            Text("Reset Progress")
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .frame(width: 0.5 * ScreenSize.width, height: 0.06 * ScreenSize.height)
                                .padding(.horizontal, 20)
                                .background(.yellow)
                                .cornerRadius(10)
                        })
                    }
                }
                
                Spacer()
            }
            .padding(.top, 0.20 * ScreenSize.width)
        }
        .ignoresSafeArea()
    }
}
