//
//  ActivityGaugeView.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/10/24.
//

import SwiftUI
import Highcharts
struct ActivityGaugeView: View {
    var body: some View {
        WeatherActivityGauge()
            .frame(height: 400)
            .padding()

    }
}

struct WeatherActivityGauge: UIViewRepresentable {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    func makeUIView(context: Context) -> HIChartView {
        let chartView = HIChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 300))
        
        let options = HIOptions()
        
        let chart = HIChart()
        chart.type = "solidgauge"
        options.chart = chart
        
        
        let title = HITitle()
        title.text = "Weather Data"
        options.title = title
        
        // Configure circular gauge
        let pane = HIPane()
        pane.center = ["50%", "50%"]
        pane.startAngle = 0
        pane.endAngle = 360
        
        // Configure background for each ring
        let background1 = HIBackground()
        background1.outerRadius = "100%"
        background1.innerRadius = "80%"
        background1.backgroundColor = HIColor(rgba: 76, green: 175, blue: 80, alpha: 0.4) // Light green
        
        let background2 = HIBackground()
        background2.outerRadius = "75%"
        background2.innerRadius = "55%"
        background2.backgroundColor = HIColor(rgba: 33, green:150, blue:243, alpha:0.4) // Light blue
        
        let background3 = HIBackground()
        background3.outerRadius = "50%"
        background3.innerRadius = "30%"
        background3.backgroundColor = HIColor(rgba: 244, green:67, blue:54, alpha:0.4) // Light red
        
        pane.background = [background1, background2, background3]
        options.pane = [pane]
        
        // Y-Axis setup
        let yAxis = HIYAxis()
        yAxis.min = 0
        yAxis.max = 100
        yAxis.lineWidth = 0
        yAxis.tickPositions = []
        options.yAxis = [yAxis]
        
        // Remove legend
        let legend = HILegend()
        legend.enabled = false
        options.legend = legend
        
        if let currentWeather = weatherViewModel.weatherData?.weatherData.data.timelines[0].intervals[0].values {
            let plotOptions = HIPlotOptions()
            let gauge = HISolidgauge()
            gauge.rounded = true
            plotOptions.solidgauge = gauge
            options.plotOptions = plotOptions
            
            let precipitation = HISolidgauge()
            precipitation.data = [["y": currentWeather.precipitationProbability, "color":"#4CAF50"]]
            precipitation.radius = "100%"
            precipitation.innerRadius = "80%"
            precipitation.color = HIColor(rgba: 76, green:175, blue:80, alpha:1.0)
            
            let humidity = HISolidgauge()
            humidity.data = [["y": currentWeather.humidity, "color": "#2196F3"]]
            humidity.radius = "75%"
            humidity.innerRadius = "55%"
            humidity.color = HIColor(rgba: 33, green:150, blue:243, alpha:1.0)


            let cloudCover = HISolidgauge()
            cloudCover.data = [["y": currentWeather.cloudCover, "color": "#F44336"]]
            cloudCover.radius = "50%"
            cloudCover.innerRadius = "30%"
            cloudCover.color = HIColor(rgba: 244, green:67, blue:54, alpha:1.0)
            
            options.series = [precipitation, humidity, cloudCover]
            
            
        }
        
        chartView.options = options
        return chartView
    }
    
    func updateUIView(_ uiView: HIChartView, context: Context) {}
}


#Preview {
    ActivityGaugeView()
}
