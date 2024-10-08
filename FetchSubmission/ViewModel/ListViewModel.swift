//
//  ListViewModel.swift
//  FetchSubmission
//
//  Created by Yongye on 10/8/24.
//

import Foundation

@Observable class ListViewModel {

    var listItems: [ListItem] = []

    init() { }

    /// Fetch a list of items from the server URL and perform deserialization
    func fetchListItems() async throws {
        guard let serverURL = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else { return }

        // fetch data asynchronously from the server url
        let (data, _) = try await URLSession.shared.data(from: serverURL)

        // parse the JSON data to swift struct
        var items = try JSONDecoder().decode([ListItem].self, from: data)

        // filter the ones whose name is blank or null
        items = items.filter {
            guard $0.name != nil else { return false }
            guard $0.name!.count > 0 else { return false }
            return true
        }

        self.listItems = items

    }
}
