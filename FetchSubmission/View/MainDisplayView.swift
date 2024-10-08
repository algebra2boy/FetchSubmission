//
//  MainDisplayView.swift
//  FetchSubmission
//
//  Created by Yongye on 10/8/24.
//

import SwiftUI

typealias GroupedListItem = [Int: [ListItem]]

/// The main display view to render a list of items
struct MainDisplayView: View {
    
    @Environment(ListViewModel.self) var listViewModel

    var body: some View {
        NavigationStack {
            VStack {
                listView()
            }
            .navigationTitle("List Items")
            .overlay(content: noItemAvailableView)
            .task {
                do {
                    try await listViewModel.fetchListItems()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @ViewBuilder func noItemAvailableView() -> some View {
        if listViewModel.listItems.isEmpty {
            ContentUnavailableView {
                Label("No item available", systemImage: "folder")
            } description: {
                Text("Please try again later.")
            }
        }
    }
    
    @ViewBuilder func listView() -> some View {
        let group = groupByListID(with: listViewModel.listItems)
        List {
            ForEach(group.keys.sorted(), id: \.self) { listId in // sort first by "listId"
                Section {
                    if let itemsBelongingToListId = group[listId] {
                        ForEach(
                            itemsBelongingToListId.sorted { $0.name! < $1.name! }
                        ) { item in // sort by "name"
                            HStack {
                                Text("id: \(item.id)")
                                Spacer()
                                Text("name: \(item.name!)")
                            }
                        }
                    }
                } header: {
                    Text("listId \(listId) (\(group[listId]?.count ?? 0) items)")
                        .font(.subheadline)
                }
            }
        }
        
    }
    
    /// Group list items using an dictionary by its list ID
    /// - Parameter items: An array of `ListItem` objects to be grouped.
    /// - Returns: A dictionary where the keys are the `listID` and the values are arrays of `ListItem` objects that belong to those list IDs.
    private func groupByListID(with items: [ListItem]) -> GroupedListItem {
        var groupedList: GroupedListItem = [:]
        for item in items {
            groupedList[item.listId, default: []].append(item)
        }
        return groupedList
    }
}

#Preview("production") {
    MainDisplayView()
        .environment(ListViewModel())
}

#Preview("mock") {
    MainDisplayView()
        .environment(ListViewModel.mock)
}
