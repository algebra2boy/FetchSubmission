//
//  ListItem.swift
//  FetchSubmission
//
//  Created by Yongye on 10/8/24.
//

import Foundation

struct ListItem: Identifiable, Decodable, Comparable, Hashable {

    var id: Int
    var listId: Int
    var name: String?

    init(id: Int, listId: Int, name: String? = nil) {
        self.id = id
        self.listId = listId
        self.name = name
    }

    static func < (lhs: ListItem, rhs: ListItem) -> Bool {
        if lhs.listId == rhs.listId {
            return lhs.name ?? "" < rhs.name ?? ""
        }
        return lhs.listId < rhs.listId
    }
}
