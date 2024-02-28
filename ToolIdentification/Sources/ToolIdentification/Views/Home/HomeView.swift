//  HomeView.swift
//  OklahomaToolIdentification
//
//  Created by Krati Mittal on 11/01/24.
//

import SwiftUI

public struct HomeView: View {
    
    @State private var navigationId = UUID()
    
    @State var showMenuView: Bool = false
    
    @ObservedObject var viewModel = HomeViewModel()
    
    @State private var showEmptyStudyDeckAlert = false
    @State private var showNoReportsAlert = false
    
    let backgroundImageName: String
    let appLogoName: String
    let practiceExamIcon: String
    let studyDeckIcon: String
    let reportsIcon: String
    
    @State private var isShowingCategorySheet = false
    @State private var isNavigationActive = false
    
    @State private var clearReports = false
    @State private var clearStudyDeck = false
    @State private var reportsConfirmationAlertVisible = false
    @State private var studyDeckConfirmationAlertVisible = false
    
    var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    public init(
        backgroundImageName: String,
        appLogoName: String,
        practiceExamIcon: String,
        studyDeckIcon: String,
        reportsIcon: String
    ) {
        self.backgroundImageName = backgroundImageName
        self.appLogoName = appLogoName
        self.practiceExamIcon = practiceExamIcon
        self.studyDeckIcon = studyDeckIcon
        self.reportsIcon = reportsIcon
    }
    
    // MARK: Body
    public var body: some View {
        NavigationView {
            ZStack {
                /// Dynamic background image
                backgroundImageView
                    .overlay(Color.black.opacity(showMenuView ? 0.4 : 0) // Black shadow overlay with opacity
                        .edgesIgnoringSafeArea(.all))
                    .onTapGesture {
                        self.showMenuView = false
                    }
                blackGradientView
                /// To manage the content over the image
                VStack {
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 24) {
                        VStack(spacing: 37) {
                            topAppLogoView
                            identifyTitleView
                        }
                        centerTileVew
                    }
                    .padding(.bottom, UIScreen.main.bounds.height * 0.2)
                    
                    Spacer()
                }
                .disabled(showMenuView)
                VStack {
                    Spacer()
                    if self.showMenuView {
                        menuOptionsView
                            .padding(.bottom, 40)
                    }
                }
                /// To manage navigation to subcategory list view using navigation link as below
                NavigationLink(
                    destination: SubcategoryListView(
                        viewModel: SubcategoryListViewModel(
                            manager: ToolIdentification.quizManager,
                            selectedCategories: self.viewModel.selectedCategoryList,
                            navigation: self.viewModel.navigation
                        )
                    )
                    .navigationBarBackButtonHidden(true),
                    isActive: .constant(!self.viewModel.selectedCategoryList.isEmpty)
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .background(.black)
            .onAppear {
                self.viewModel.selectedCategoryList.removeAll()
                self.isNavigationActive = false
                self.showMenuView = false
                self.orientation = UIDevice.current.orientation
            }
            .onDisappear(perform: {
                self.showMenuView = false
            })
            /// Show category alert on selection of Start Practice
            .alert("Select Category", isPresented: self.$isShowingCategorySheet) {
                VStack {
                    let sortedCategories = self.viewModel.categoryNames.sorted(by: { $0 > $1 })
                    ForEach(sortedCategories, id: \.self) { category in
                        Button(action: {
                            self.viewModel.selectedCategoryList = [category]
                            self.isShowingCategorySheet = false
                            self.isNavigationActive = true
                        }) {
                            Text(category)
                        }
                    }
                    /// When the categories are more than 1
                    if self.viewModel.categoryNames.count > 1 {
                        Button(action: {
                            self.viewModel.selectAllCategories()
                            self.isShowingCategorySheet = false
                            self.isNavigationActive = true
                        }) {
                            Text(self.viewModel.categoryNames.count > 2
                                 ? "All"
                                 : "Both")
                        }
                    }
                    // To toggle isShowingCategorySheet to false
                    Button(action: {
                        self.isShowingCategorySheet = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                }
            }
            .onTapGesture {
                self.showMenuView = false
            }
            /// Show Empty Study Deck Alert
            .alert("", isPresented: self.$showEmptyStudyDeckAlert, actions: {
                Button {
                    self.showMenuView = false
                } label: {
                    Text("OK")
                }

            }, message: {
                Text("No questions are in the Study Deck.")
            })
            /// Show No reports available alert
            .alert("", isPresented: self.$showNoReportsAlert, actions: {
                Button {
                    self.showMenuView = false
                } label: {
                    Text("OK")
                }

            }, message: {
                Text("No Reports Available.")
            })
            /// Reports clearance alert
            .alert("", isPresented: self.$clearReports, actions: {}, message: {
                Text("Reports cleared for all chapters.")
            })
            /// Study deck clearance alert
            .alert("", isPresented: self.$clearStudyDeck, actions: {}, message: {
                Text("Removed all chapters from study deck.")
            })
        }
        .id(navigationId)
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("popToRootView"))) { output in
            navigationId = UUID()
        }
    }
    
    // MARK: Background Image
    var backgroundImageView: some View {
        Image(self.backgroundImageName, bundle: .module)
            .resizable()
            .frame(maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: Black Gradient
    var blackGradientView: some View {
        VStack {
            LinearGradient(
                colors: [
                    .black,
                    .clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: UIScreen.main.bounds.height/1.2)
            
            Spacer()
        }
    }
    
    // MARK: App Logo
    var topAppLogoView: some View {
        ZStack {
            HStack {
                Image(self.appLogoName, bundle: .module)
                    .resizable()
                    .frame(width: 200, height: 100)
                    .padding(.top, 20)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    self.showMenuView.toggle()
                }, label: {
                    Image("menu", bundle: .module)
                        .resizable()
                        .frame(width: 5, height: 20)
                })
                .padding(.trailing, 24)
            }
        }
    }
    
    // MARK: Title
    var identifyTitleView: some View {
        VStack(spacing: 12) {
            Text("Identify")
                .foregroundColor(.white)
                .font(.system(size: 36, weight: .semibold))
            
            RoundedRectangle(cornerRadius: 4)
                .frame(
                    width: 35,
                    height: 4
                )
                .foregroundColor(.white)
        }
    }
    
    // MARK: Center Tiles
    // Start Practice, Study Deck and Reports
    var centerTileVew: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                Spacer()
                // Start Practice
                /// Navigation being managed in the body using NavigationLink - Line no. 63
                Button {
                    self.viewModel.navigation = .quiz
                    self.isShowingCategorySheet = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                .gray,
                                lineWidth: 2
                            )
                            .background(.black.opacity(0.3))
                            .frame(height: 120)
                            .padding(
                                .horizontal,
                                24
                            )
                        
                        VStack(spacing: 8, content: {
                            Image(self.practiceExamIcon, bundle: .module)
                                .frame(
                                    width: 24,
                                    height: 24
                                )
                            
                            Text("Start Practice")
                                .padding(.horizontal, 14)
                            // FIXME: Font to be updated below with Lato
                                .font(.custom("Helvetica Neue Medium", size: 16))
                                .foregroundColor(.white)
                        })
                    }
                    .frame(width: isIPad ? (UIDevice.current.orientation.isLandscape ? 600 : 400) : nil)

                }
                .buttonStyle(PlainButtonStyle())
                
                HStack(spacing: 11) {
                    // Study Deck
                    Button {
                        if let studyDeckQuestions = RealmManager.questionsAddedToStudyDeck(), !studyDeckQuestions.isEmpty {
                            self.viewModel.navigation = .studyDeck
                            self.isShowingCategorySheet = true
                        } else {
                            self.showEmptyStudyDeckAlert = true
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    .gray,
                                    lineWidth: 2
                                )
                                .background(.black.opacity(0.3))
                                .frame(height: 120)
                            
                            VStack(spacing: 8, content: {
                                Image(self.studyDeckIcon, bundle: .module)
                                    .frame(
                                        width: 24,
                                        height: 24
                                    )
                                
                                Text("Review My Study Deck")
                                    // FIXME: Font to be updated below with Lato
                                    .padding(.horizontal, 14)
                                    .font(.custom("Helvetica Neue Medium", size: 16))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            })
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: isIPad ? (UIDevice.current.orientation.isLandscape ? 270 : 170) : nil)
                    
                    // View Reports
                    Button {
                        if let reportsAvailable = RealmManager.reportsAvailableForCategories(), !reportsAvailable.isEmpty {
                            self.viewModel.navigation = .reports
                        } else {
                            self.showNoReportsAlert = true
                        }
                    } label: {
                        if let reportsAvailable = RealmManager.reportsAvailableForCategories(), !reportsAvailable.isEmpty {
                            NavigationLink(
                                destination: ReportsSelectCategoryView(viewModel: ReportsViewModel())
                                    .navigationBarBackButtonHidden(true)
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            Color.gray,
                                            lineWidth: 2
                                        )
                                        .background(.black.opacity(0.3))
                                        .frame(height: 120)
                                    
                                    VStack(spacing: 8) {
                                        Image(self.reportsIcon, bundle: .module)
                                            .frame(
                                                width: 24,
                                                height: 24
                                            )
                                        
                                        Text("View Reports")
                                            .padding(.horizontal, 14)
                                            .font(.custom("Helvetica Neue Medium", size: 16))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color.gray,
                                        lineWidth: 2
                                    )
                                    .background(Color.black.opacity(0.3))
                                    .frame(height: 120)
                                
                                VStack(spacing: 8) {
                                    Image(self.reportsIcon, bundle: .module)
                                        .frame(
                                            width: 24,
                                            height: 24
                                        )
                                    
                                    Text("View Reports")
                                        .font(.custom("Helvetica Neue Medium", size: 16))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: isIPad ? (UIDevice.current.orientation.isLandscape ? 270 : 170) : nil)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: geometry.size.width)
                Spacer()
            }
            .frame(maxWidth: geometry.size.width)
        }
    }
    
    // MARK: Menu options view - Clear study deck/test reports
    var menuOptionsView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
            HStack {
                VStack(spacing: 32) {
                    // Clear Study Deck
                    Button(action: {
                        if let studyDeckQuestions = RealmManager.questionsAddedToStudyDeck(), !studyDeckQuestions.isEmpty {
                            self.studyDeckConfirmationAlertVisible = true
                        } else {
                            self.showEmptyStudyDeckAlert = true
                        }
                    }, label: {
                        Text("Clear Study Deck")
                            .foregroundColor(.white)
                            .font(.custom("Lato-Bold", size: 16))
                    })
                    .alert(isPresented: self.$studyDeckConfirmationAlertVisible) {
                        Alert(title: Text("Reset"),
                              message: Text("Clear all study deck questions?"),
                              primaryButton: .cancel(Text("No"), action: {
                            self.showMenuView = false
                        }),
                              secondaryButton: .default(Text("Yes"),
                                                        action: {
                            RealmManager.clearStudyDeck()
                            self.clearStudyDeck = true
                            self.showMenuView = false
                        }))
                    }
                    // Clear Reports
                    Button(action: {
                        if let reportsAvailable = RealmManager.reportsAvailableForCategories(), !reportsAvailable.isEmpty {
                            self.reportsConfirmationAlertVisible = true
                        } else {
                            self.showNoReportsAlert = true
                        }
                    }, label: {
                        Text("Clear Test Results")
                            .foregroundColor(.white)
                            .font(.custom("Lato-Bold", size: 16))
                    })
                    .alert(isPresented: self.$reportsConfirmationAlertVisible) {
                        Alert(title: Text("Reset"),
                              message: Text("Clear all test results?"),
                              primaryButton: .cancel(Text("No"), action: {
                            self.showMenuView = false
                        }),
                              secondaryButton: .default(Text("Yes"),
                                                        action: {
                            RealmManager.clearReports()
                            self.clearReports = true
                            self.showMenuView = false
                        }))
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .foregroundColor(Color(red: 52/255, green: 52/255, blue: 52/255))
        .frame(height: 120)
        .padding(.horizontal, 10)
    }
}
