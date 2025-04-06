//
//  ExerciseMetricChart.swift
//  Exercisely
//
//  Created by Jason Vance on 4/4/25.
//

import SwiftUI

//TODO: RELEASE: Put units on the left axis
//TODO: Allow interaction with the points
//TODO: Add ability to change the dates
struct ExerciseMetricChart: View {
    
    private let leadingMargin: CGFloat = 24
    private let bottomMargin: CGFloat = 36
    private let bottomLabelWidth: CGFloat = 50
    
    private let capsuleWidth: CGFloat = 14

    @Environment(\.displayScale) private var displayScale
    
    struct Value: Identifiable, Equatable {
        var id: SimpleDate { date }
        let date: SimpleDate
        let values: [Double]
    }
    
    @State private var minDate: SimpleDate = .today.adding(days: -56)
    @State private var maxDate: SimpleDate = .today
    
    let values: [Value]
    
    private var minValue: Double {
        let rawMin = values
            .reduce(into: []) { flattenedValues, value in
                flattenedValues.append(contentsOf: value.values)
            }
            .min() ?? 0
        
        return Double(Int(rawMin) / 10 * 10)
    }
    
    private var maxValue: Double {
        let rawMax = values
            .reduce(into: []) { flattenedValues, value in
                flattenedValues.append(contentsOf: value.values)
            }
            .max() ?? 1
        
        return Double((Int(rawMax) / 10 + 1) * 10)
    }
    
    private var sortedValues: [Value] {
        values
            .sorted { $0.date < $1.date }
            .filter { $0.date >= minDate && $0.date <= maxDate }
    }
        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .top) {
                    LeftAxis()
                    ChartedValues(geometry)
                }
                BottomAxis()
            }
            
        }
        .padding(.vertical)
        .padding(.trailing)
        .foregroundStyle(Color.text)
        .background(Color.background)
        .animation(.snappy, value: values)
    }
    
    @ViewBuilder private func ChartedValues(_ geometry: GeometryProxy) -> some View {
        let totalDays = minDate.daysTo(maxDate)
        let totalWidth = geometry.size.width - leadingMargin - .padding
        let xOffsetPerDay = totalWidth / CGFloat(totalDays)
        
        let totalHeight = geometry.size.height - bottomMargin
        let yOffsetPerUnit = totalHeight / CGFloat(maxValue - minValue)
        
        ForEach(sortedValues, id: \.id) { value in
            let day = minDate.daysTo(value.date)
            let unitsAboveMin = value.values.min()! - minValue
            let heightInUnits = (value.values.max()! - value.values.min()!)
            let height = heightInUnits * yOffsetPerUnit
            
            Capsule()
                .frame(width: capsuleWidth, height: capsuleWidth + height)
                .offset(
                    x: leadingMargin + (CGFloat(day) * xOffsetPerDay) - (capsuleWidth / 2) - (totalWidth / 2),
                    y: totalHeight - ((height) + (unitsAboveMin * yOffsetPerUnit))
                )
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func BottomAxis() -> some View {
        let midDate = SimpleDate.midDate(self.minDate, self.maxDate)
        let quarter1Date = SimpleDate.midDate(self.minDate, midDate)
        let quarter3Date = SimpleDate.midDate(self.maxDate, midDate)

        HStack {
            Rectangle()
                .frame(width: leadingMargin, height: 1)
                .opacity(0)
            Text(minDate.formatted(as: .abbreviatedMonthDay))
                .frame(width: bottomLabelWidth)
                .offset(x: -bottomLabelWidth / 3)
            Spacer()
            Text(quarter1Date.formatted(as: .abbreviatedMonthDay))
                .frame(width: bottomLabelWidth)
                .offset(x: -bottomLabelWidth / 6)
            Spacer()
            Text(midDate.formatted(as: .abbreviatedMonthDay))
                .frame(width: bottomLabelWidth)
            Spacer()
            Text(quarter3Date.formatted(as: .abbreviatedMonthDay))
                .frame(width: bottomLabelWidth)
                .offset(x: bottomLabelWidth / 6)
            Spacer()
            Text(maxDate.formatted(as: .abbreviatedMonthDay))
                .frame(width: bottomLabelWidth)
                .offset(x: bottomLabelWidth / 3)
        }
        .font(.caption2)
        .contentTransition(.numericText())
    }
    
    @ViewBuilder private func LeftAxis() -> some View {
        VStack {
            HStack {
                Text(maxValue.formatted())
                    .frame(width: leadingMargin, alignment: .trailing)
                Rectangle()
                    .chartLine(displayScale: displayScale)
            }
            Spacer()
            HStack {
                Text(((minValue + maxValue) / 2).rounded(.down).formatted())
                    .frame(width: leadingMargin, alignment: .trailing)
                Rectangle()
                    .chartLine(displayScale: displayScale)
            }
            Spacer()
            HStack {
                Text(minValue.formatted())
                    .frame(width: leadingMargin, alignment: .trailing)
                Rectangle()
                    .chartLine(displayScale: displayScale)
            }
        }
        .font(.caption2)
        .contentTransition(.numericText())
    }
}

fileprivate extension View {
    func chartLine(displayScale: CGFloat) -> some View {
        self
            .frame(width: .infinity, height: 1.0 / displayScale)
            .opacity(0.5)
    }
}

#Preview {
    let values: [ExerciseMetricChart.Value] = [
        .init(date: .today, values: [16,17,18,19]),
        .init(date: .today.adding(days: -7), values: [13,14,15]),
        .init(date: .today.adding(days: -14), values: [11,12]),
        .init(date: .today.adding(days: -21), values: [10]),
        .init(date: .today.adding(days: -28), values: [6,7,8,9]),
        .init(date: .today.adding(days: -35), values: [5]),
        .init(date: .today.adding(days: -42), values: [2,3,4]),
        .init(date: .today.adding(days: -49), values: [1]),
        .init(date: .today.adding(days: -56), values: [0])
    ]
    
    ExerciseMetricChart(values: values)
        .frame(height: 300)
}
