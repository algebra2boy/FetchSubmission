//
//  ContentView.swift
//  FetchSubmission
//
//  Created by Yongye on 10/8/24.
//

import SwiftUI

struct ContentView: View {

    @State private var listViewModel: ListViewModel = ListViewModel()

    var body: some View {
        MainDisplayView()
            .environment(listViewModel)
    }
}

#Preview {
    ContentView()
}
