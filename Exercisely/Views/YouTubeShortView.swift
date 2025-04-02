//
//  YouTubeShortView.swift
//  Exercisely
//
//  Created by Jason Vance on 4/1/25.
//

import SwiftUI

struct YouTubeShortView: View {
    
    @Environment(\.displayScale) var displayScale

    private let youtubeShortUrl: String
    
    init(youtubeShortUrl: String) {
        self.youtubeShortUrl = youtubeShortUrl
            .replacingOccurrences(of: "shorts", with: "embed")
    }
    
    private var html: String {
        """
        <iframe allowtransparency="true" style="background: #00000000;" 
        width="100%" height="100%"
        src="\(youtubeShortUrl)"
        title="YouTube video player"
        frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowfullscreen></iframe>
        """
    }
    var body: some View {
        WebView(html: html)
    }
}

#Preview {
    YouTubeShortView(youtubeShortUrl: "https://www.youtube.com/embed/1rLzHVL50OA?si=6f0qcbuH4rsEKRHB")
}
