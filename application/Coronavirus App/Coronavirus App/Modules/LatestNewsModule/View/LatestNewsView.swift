//
//  LatestNewsView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import SwiftUI

struct LatestNewsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: LatestNewsViewModel
    
    init(viewModel: LatestNewsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        initAppereance()
    }
    
    private func initAppereance(){
        if let font = UIFont(name: "Montserrat-Bold", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [.font : font]
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                if let news = viewModel.news {
                    if let error = viewModel.error {
                        errorViewBuilder(error)
                            .navigationBarHidden(true)
                    } else if viewModel.loader {
                        VStack {
                            LoaderView()
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
                            
                            Spacer()
                        }
                        .addAppThemeBackground()
                        
                    } else {
                        ZStack(alignment: .top) {
                            virusImage(blur: 3)
                                .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.55)
                                .offset(x: geo.size.width * 0.4, y: geo.size.height * 0.1)
                            
                            virusImage(blur: 1)
                                .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.16)
                                .offset(x: -(geo.size.width * 0.1), y: -(geo.size.height * 0.02))
                                .rotationEffect(Angle(degrees: 35))
                            
                            virusImage(blur: 1)
                                .frame(width: geo.size.width * 0.25, height: geo.size.height * 0.25)
                                .offset(x: geo.size.width * 0.4, y: -(geo.size.height * 0.08))
                            
                            virusImage(blur: 3)
                                .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.25)
                                .offset(x: -(geo.size.width * 0.4), y: -(geo.size.height * 0.08))
                            
                            ScrollView {
                                RefreshHandler(coordinateSpaceName: "refreshHandler") {
                                    viewModel.refreshLatestNews(true)
                                }
                                
                                list(news:news, geo: geo)
                            }
                            .coordinateSpace(name: "refreshHandler")
                            .onAppear {
                                viewModel.handleOnAppearEvent(&UIScrollView.appearance().bounces)
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarItems(
                            leading:
                                Text(verbatim: .latestNewsTitle)
                                    .commonFont(.semiBold, style: .title2)
                                    .padding()
                        )
                        .addAppThemeBackground()
                    }
                } else {
                    ErrorView(.general){
                        viewModel.refreshLatestNews(false)
                    }
                }
            }
        }
    }
}
extension LatestNewsView {
    @ViewBuilder
    private func virusImage(blur: CGFloat) -> some View {
        Image("virus")
            .resizable()
            .scaledToFit()
            .opacity(0.68)
            .blur(radius: blur)
    }
    
    @ViewBuilder
    private func list(news: [LatestNewsDetails], geo: GeometryProxy) -> some View {
        LazyVStack {
            ForEach(news){ item in
                NavigationLink(isActive: $viewModel.isWebViewPresented) {
                    if viewModel.isWebViewPresented {
                        WebView(url: viewModel.webViewUrl!)
                            .navigationOverride(colorScheme: colorScheme) {
                                viewModel.handleWebViewPresentation(status: .dismissed, item: item)
                            }
                            .navigationBarTitle(Text(verbatim: .latestNewsTitle), displayMode: .inline)
                            .addAppThemeBackground()
                    }
                } label: {
                    LatestNewsListItemView(item: item, geo: geo)
                        .padding([.leading, .trailing, .bottom])
                        .onTapGesture {
                            viewModel.handleWebViewPresentation(status: .presented, item: item)
                        }
                }
            }
            
            if viewModel.isLastNews == false {
                ProgressView()
                    .onAppear {
                        viewModel.loadMoreNews()
                    }
            } else {
                Text("No more news")
                    .commonFont(.regular, style: .body)
                    .padding()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func emptyError() -> some View {
        VStack(alignment: .center){
            Text("No available data")
                .commonFont(.semiBold, style: .headline)
                .padding()
        }
    }
    
    @ViewBuilder
    private func errorViewBuilder(_ error: ErrorType) -> some View {
        switch error {
        case .general:
            ErrorView(.general) {
                viewModel.errorActionCallback()
            }
        case .noInternetConnection:
            ErrorView(.noInternetConnection) {
                viewModel.errorActionCallback()
            }
        case .empty:
            emptyError()
        }
    }
}

struct LatestNewsView_Previews: PreviewProvider {
    static var previews: some View {
        LatestNewsView(
            viewModel: LatestNewsViewModel(
                repository: LatestNewsRepositoryImpl()
            )
        )
    }
}

