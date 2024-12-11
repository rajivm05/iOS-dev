//
//  SummaryCompile.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/9/24.
//

import SwiftUI

struct SummaryCompile: View {
    var body: some View {
            VStack(spacing:40){
                SummaryCard()
                WeatherMetrics()
                ForecastTable()
            }.padding(.all, 25)
        
    }
}

#Preview {
    SummaryCompile().environmentObject(WeatherViewModel())
}
