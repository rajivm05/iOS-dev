//
//  WeatherDetailsView.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/10/24.
//

import SwiftUI

struct WeatherDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: LocationViewModel
    @State private var selectedTab = 0
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    var body: some View {
        ZStack{
            TabView(selection:$selectedTab) {
                GridView().tabItem{
                    Image("Today_Tab")
                    Text("Today")
                }.tag(0)
                WeeklyView().tabItem{
                    Image("Weekly_Tab")
                    Text("Weekly")
                }.tag(1)
                KeyData().tabItem{
                    Image("Weather_Data_Tab")
                    Text("Weather Data")
                }.tag(2)
            }
        }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(extractCity(from: viewModel.formattedAddress))
            .navigationBarItems(trailing: Button(action:{}) {Image("twitter")})
            .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Weather")
                        }
                        .foregroundColor(.blue)
                    }
                )
//                .onAppear {
//                    weatherViewModel.loadLocalWeatherData()
//                }
    }
}
#Preview {
    WeatherDetailsView().environmentObject(WeatherViewModel())
}

