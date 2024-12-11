//
//  KeyData.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/10/24.
//

import SwiftUI

struct KeyData: View {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    var body: some View {
        VStack{
            KeySubViewTop()
            ActivityGaugeView()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Image("App_background").resizable().aspectRatio(contentMode: .fill)
//                .edgesIgnoringSafeArea(.all)
            )
//            .onAppear {
//                weatherViewModel.loadLocalWeatherData()
//            }
    }
}

#Preview {
    KeyData().environmentObject(WeatherViewModel())
}
