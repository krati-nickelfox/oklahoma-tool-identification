//
//  CustomBottomSheet.swift
//
//
//  Created by Chakshu Dawara on 27/02/24.
//

import SwiftUI

struct CustomBottomSheet<Content: View>: View {
    
    // MARK: Properties
    @Binding var isSheetVisible: Bool
    
    @ViewBuilder let content: () -> Content
    let leadingTrailingPadding: CGFloat?
    
    var isiPad: Bool {
           UIDevice.current.userInterfaceIdiom == .pad
       }
    
    init(isSheetVisible: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, leadingTrailingPadding: CGFloat? = 20) {
        self._isSheetVisible = isSheetVisible
        self.content = content
        self.leadingTrailingPadding = leadingTrailingPadding
    }
    
    // MARK: Body
    var body: some View {
        
        /// Color: Background view for bottom sheet
        Color(.black)
            .opacity(0.7)
            .ignoresSafeArea()
            .frame(height: UIScreen.main.bounds.size.height)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.isSheetVisible = false
                }
            }
            .animation(
                .easeIn(duration: 0.3),
                value: self.isSheetVisible
            )
            .transition(
                .opacity
            )
        
        /// Sheet: Bottom sheet content
        VStack(spacing: 8) {
            Spacer()
            
            /// Sheet: Dynamic sheet content
            VStack {
                self.content()
                    .padding([.bottom], 24)
                    .padding(.horizontal, leadingTrailingPadding)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)
            .frame(width: isiPad ? UIScreen.main.bounds.width/2 : UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height/2 + 80)
            .background(Color(red: 35/255, green: 31/255, blue: 32/255))
            .cornerRadius(24, corners: [.topLeft, .topRight])

        }
        .ignoresSafeArea()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottom
        )
        .animation(
            .easeInOut(duration: 0.3),
            value: true
        )
        .transition(
            .asymmetric(
                insertion:
                        .move(edge: .bottom)
                        .animation(.easeInOut(duration: 0.3)),
                removal:
                        .move(edge: .bottom)
                        .animation(.easeInOut(duration: 0.3))
            )
        )
        .zIndex(1)

    }
    
    // MARK: Cross Button
    var crossButton: some View {
        VStack {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.isSheetVisible = false
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .padding(.all, 13)
                    .foregroundColor(Color.white)
            }
            .background(Color.black)
            .frame(width: 40, height: 40, alignment: .center)
            .cornerRadius(UIScreen.main.bounds.height/2)
        }
    }

}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}
