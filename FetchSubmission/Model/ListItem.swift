//
//  ListItem.swift
//  FetchSubmission
//
//  Created by Yongye on 10/8/24.
//

import Foundation

/// An struct that represents the `ListItem` structure
struct ListItem: Identifiable, Decodable, Hashable {

    var id: Int
    var listId: Int
    var name: String?

    init(id: Int, listId: Int, name: String? = nil) {
        self.id = id
        self.listId = listId
        self.name = name
    }
}
