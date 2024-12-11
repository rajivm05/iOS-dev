//
//  TemperatureTrendView.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/10/24.
//

import SwiftUI
import Highcharts
struct TemperatureTrendView: View {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    var body: some View {
        VStack{
            WeatherChartView()
                .frame(height: 300)
        }
        
    }
}

struct WeatherChartView: UIViewRepresentable {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    func makeUIView(context: Context) -> HIChartView {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 300)
        let chartView = HIChartView(frame: frame)
        let options = HIOptions()
        
        // Chart configuration
        let chart = HIChart()
        chart.type = "arearange"
        options.chart = chart
        
        // Y-Axis
        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = "Temperatures"
//        yAxis.min = NSNumber(value: 75)
//        yAxis.max = NSNumber(value: 81)
        yAxis.tickInterval = 3
        yAxis.gridLineWidth = 1
//        yAxis.gridLineColor = "#E0E0E0"
        options.yAxis = [yAxis]
        
        // X-Axis
        let xAxis = HIXAxis()
        xAxis.gridLineWidth = 0
//        xAxis.min = 0
//        xAxis.max = 6
        xAxis.tickInterval = 1
        options.xAxis = [xAxis]
        
        let legend = HILegend()
        legend.enabled = false
        options.legend = legend
        
        let title = HITitle()
        title.text = "Temperature Variation by Day"
        title.style = HICSSObject()
        title.style.fontSize = "16px"
        options.title = title

        
        // Series
        let series = HIArearange()
//        series.name = ""
        
        var processedData : [[Any]] = []
        var minTemps: [String:Double] = [:]
        var maxTemps: [String:Double] = [:]
        if let intervals = weatherViewModel.weatherData?.weatherData.data.timelines[1].intervals {
            for interval in intervals{
                let date = formatDateTime(interval.startTime).date
                let temp = interval.values.temperature
                if let curMin = minTemps[date]{
                    if temp < curMin{
                        minTemps[date] = temp
//                        print("Updated min temp: \(temp)")
                    }
                }else{
                    minTemps[date] = temp
                }
                if let curMax = maxTemps[date]{
                    if temp > curMax{
                        maxTemps[date] = temp
//                        print("Updated max temp: \(temp)")
                    }
                }else{
                    maxTemps[date] = temp
                }
            }
            for (index, date) in minTemps.keys.enumerated(){
                let minTemp = minTemps[date]!
                let maxTemp = maxTemps[date]!
                processedData.append([index, Int(minTemp), Int(maxTemp)])
            }
//            print(processedData)
            series.data = processedData
        }
        
        
        
        // Style the series
        series.fillColor = HIColor(linearGradient: [
            "x1": 0, "y1": 0, "x2": 0, "y2": 1
        ], stops: [
            [0, "rgba(255, 200, 124, 0.8)"],
            [1, "rgba(200, 200, 200, 0.3)"]
        ])
        series.lineWidth = 0
        series.marker = HIMarker()
        series.marker.enabled = true
        series.marker.radius = 4
        series.marker.fillColor = HIColor(name: "#000000")
        
        options.series = [series]
        chartView.options = options
        
        return chartView
    }
    
    func updateUIView(_ uiView: HIChartView, context: Context) {}
}

#Preview {
    TemperatureTrendView().environmentObject(WeatherViewModel())
}
