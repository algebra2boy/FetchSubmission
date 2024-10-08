//
//  ListViewModel.swift
//  FetchSubmission
//
//  Created by Yongye on 10/8/24.
//

import Foundation

/// a view model that handles the manage the list item
@Observable class ListViewModel {

    /// An array of list items with information like `id`, `listId`, and `name`
    var listItems: [ListItem]

    /// Flag to indicate if the view model is in mock mode
    private var isMock: Bool

    init(listItem: [ListItem] = [], isMock: Bool = false) {
        self.listItems = listItem
        self.isMock = isMock
    }

    /// Fetch a list of items from the server URL and perform deserialization
    func fetchListItems() async throws {

        // skip fetching when it is in the mock enviornment
        guard !isMock else { return }

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

    /// a mock view model that simulates fetching when server is not available
    static let mock: ListViewModel = {
        let items: [ListItem] = [
            .init(id: 1, listId: 1, name: "Item 1"),
            .init(id: 2, listId: 1, name: "Item 2"),
            .init(id: 3, listId: 1, name: "Item 3")
        ]
        return .init(listItem: items, isMock: true)
    }()
}
