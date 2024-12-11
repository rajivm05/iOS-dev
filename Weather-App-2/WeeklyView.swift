//
//  WeeklyView.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/10/24.
//

import SwiftUI

struct WeeklyView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var body: some View {
        VStack {
//            Spacer()
            WeeklySummaryCard().padding(.bottom, 60)
//            Spacer()
            TemperatureTrendView()
//            Spacer()
        }.padding(.horizontal, 10)
//        .onAppear {
//            weatherViewModel.loadLocalWeatherData()
//        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Image("App_background").resizable().aspectRatio(contentMode:.fill)
//            .edgesIgnoringSafeArea(.bottom)
            )
        
    }
        
}

#Preview {
    WeeklyView().environmentObject(WeatherViewModel())
}
