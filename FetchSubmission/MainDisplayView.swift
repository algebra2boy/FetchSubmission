//
//  MainDisplayView.swift
//  FetchSubmission
//
//  Created by Yongye on 10/8/24.
//

import SwiftUI

typealias GroupedListItem = [Int: [ListItem]]

struct MainDisplayView: View {
    
    @State private var listViewModel: ListViewModel = ListViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack {
                listView()
            }
            .navigationTitle("List Items")
            .task {
                do {
                    try await listViewModel.fetchListItems()
                    //                    print(listViewModel.listItems)
                    print(groupByListID(with: listViewModel.listItems))
                } catch {
                    
                }
            }
        }
    }
    
    @ViewBuilder func listView() -> some View {
        let group = groupByListID(with: listViewModel.listItems)
        List {
            ForEach(group.keys.sorted(), id: \.self) { key in
                Section {
                    if let itemsBelongingToListID = group[key] {
                        ForEach(itemsBelongingToListID) { item in
                            HStack {
                                Text("id: \(item.id)")
                                Spacer()
                                Text("name: \(item.name!)")
                            }
                        }
                    }
                } header: {
                    Text("listId \(key)")
                        .font(.subheadline)
                }
            }
        }
    }
    
    private func groupByListID(with items: [ListItem]) -> GroupedListItem {
        var groupedList: GroupedListItem = [:]
        for item in items {
            groupedList[item.listId, default: []].append(item)
        }
        return groupedList
    }
}

#Preview {
    MainDisplayView()
}
