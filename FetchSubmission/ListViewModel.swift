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

    func fetchListItems() async throws {
        guard let serverURL = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else { return }

        // fetch data asynchronously from the server url
        let (data, _) = try await URLSession.shared.data(from: serverURL)

        // parse the JSON data to swift struct
        var items = try JSONDecoder().decode([ListItem].self, from: data)

        // filter the ones whose name is blank or null
        // and then sort by "listId" and then by "name"
        items = items.filter {
            guard $0.name != nil else { return false }
            guard $0.name!.count > 0 else { return false }
            return true
        }
        .sorted()

        self.listItems = items

    }
}
