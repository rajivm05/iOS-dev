//
//  ContentView.swift
//  Weather-App-ios
//
//  Created by Rajiv Murali on 12/2/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var showSplash = true
    @EnvironmentObject private var locationService:LocationService
    @EnvironmentObject private var viewModel: LocationViewModel
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    var body: some View {
        Group {
                    if showSplash {
                        LaunchUI()
                    } else {
                        ContentView_()
                        
                    }
                }
                .onAppear {
                    // Timer to hide the splash screen after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSplash = false
                        }
                        print(viewModel.formattedAddress)
                        print(viewModel.coordinate)
                    }
                }
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let weatherViewModel = WeatherViewModel()
//        ContentView()
//            .environmentObject(LocationService(weatherViewModel: weatherViewModel))
//            .environmentObject(weatherViewModel)
//            .environmentObject(LocationViewModel(weatherViewModel: weatherViewModel))
//    }
//}
struct ContentView_: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var body: some View {
        NavigationView {
            ZStack {
                SummaryCompile()
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Image("App_background").resizable().aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all))
//                .onAppear {
//                    weatherViewModel.loadLocalWeatherData()
//                }
        }
    }
}
#Preview {
    ContentView()
}
