//
//  SearchResultView.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/11/24.
//

import SwiftUI
import SimpleToast
import SwiftSpinner

struct SearchResultView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var viewModel: LocationViewModel
    @EnvironmentObject private var locationService: LocationService
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    @State private var selectedTab = 0
    
    @State private var showToast = false
    private let toastOptions = SimpleToastOptions(
            alignment: .bottom,
            hideAfter: 2,
            backdropColor: Color.black.opacity(0.2),
            animation: .default,
            modifierType: .slide
        )
    
    
    @State private var isFavorite: Bool = false
    var favoriteFunctions:FavoriteFunctions = FavoriteFunctions()
    
    var body: some View {
        ZStack{
            Image("App_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                HStack{
                    Spacer()
                    FavoriteToggleButton(isFavorite: isFavorite, onToggle: {
                        Task{
                            if isFavorite{
                                isFavorite.toggle()
                                try await favoriteFunctions.deleteFavorite(lat: String(viewModel.coordinate.latitude), lng: String(viewModel.coordinate.longitude))
                                self.showToast = true
                            }
                            else{
                                if let rawData = weatherViewModel.weatherData{
                                    isFavorite.toggle()
                                    try await favoriteFunctions.addFavorite(formattedAddress: viewModel.formattedAddress, rawData: rawData, lat: String(viewModel.coordinate.latitude), lng: String(viewModel.coordinate.longitude))
                                    self.showToast = true

                                }
                            }
                            
                        }
                        
                    }).padding(.trailing, 30)
                }
                SummaryCompile()
            }.simpleToast(isPresented: $showToast, options: toastOptions) {
                if isFavorite{
                    HStack(spacing: 10) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("Added to favorites")
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(20)
                }
                else{
                    HStack(spacing: 10) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("Removed from favorites")
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(20)
                }
                
            }
        }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(extractCity(from: viewModel.formattedAddress))
            .navigationBarItems(trailing: Button(action: {
                shareToTwitter(
                        city:  extractCity(from: viewModel.formattedAddress) ?? "",
                        temperature: weatherViewModel.weatherData?.weatherData.data.timelines.first?.intervals.first?.values.temperature ?? 0.0,
                        condition: getWeatherStatus(code: weatherViewModel.weatherData?.weatherData.data.timelines.first?.intervals.first?.values.weatherCode ?? 1000) ?? ""
                    )
            }) {Image("twitter")})
            .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        viewModel.updateLocation(latitude: locationService.coordinate.latitude, longitude: locationService.coordinate.longitude)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Weather")
                        }
                        .foregroundColor(.blue)
                    }
                )
//                .onAppear(){
//                    SwiftSpinner.show(duration: 4.0, title: "Fetching weather details for \(viewModel.formattedAddress)")
//                }
    }
}

#Preview {
    SearchResultView()
}
