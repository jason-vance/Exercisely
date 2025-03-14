//
//  NavigationLinkNoChevron.swift
//  Exercisely
//
//  Created by Jason Vance on 3/14/25.
//

import SwiftUI

struct NavigationLinkNoChevron<Label, Destination>: View where Label : View, Destination : View {
    
    private let destination: () -> Destination
    private let label: () -> Label
    
    public init(
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.destination = destination
        self.label = label
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationLink(destination: destination()) {
                EmptyView()
            }
            .opacity(0)
            label()
        }
    }
}

#Preview {
    NavigationStack {
        List {
            NavigationLinkNoChevron {
                Text("Destination")
            } label: {
                Text("Navigation Link")
            }
        }
    }
}
