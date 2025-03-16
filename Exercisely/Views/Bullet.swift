//
//  Bullet.swift
//  Exercisely
//
//  Created by Jason Vance on 3/15/25.
//

import SwiftUI

struct Bullet: View {
    var body: some View {
        Image(systemName: "circle.fill")
            .resizable()
            .frame(width: .activityRowBulletSize, height: .activityRowBulletSize)
    }
}

#Preview {
    Bullet()
}
