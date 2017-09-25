// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

struct ViewReuseCollection {

    typealias DictionaryType = [String : [View]]

    fileprivate var views = DictionaryType()


    subscript(viewReuseId: String) -> [View] {
        get {
            return self.views[viewReuseId] ?? []
        }
        set {
            self.views[viewReuseId] = newValue
        }
    }

    mutating func insert(_ view: View, viewReuseId: String) {
        var viewsWithReuseId = self[viewReuseId]
        viewsWithReuseId.append(view)
        self[viewReuseId] = viewsWithReuseId
    }

    mutating func pop(viewReuseId: String) -> View? {
        var viewsWithReuseId = self[viewReuseId]
        let view = viewsWithReuseId.popLast()
        self[viewReuseId] = viewsWithReuseId
        return view
    }

    mutating func remove(_ view: View, viewReuseId: String) {
        var viewsWithReuseId = self[viewReuseId]
        if let index = viewsWithReuseId.index(of: view) {
            viewsWithReuseId.remove(at: index)
            self[viewReuseId] = viewsWithReuseId
        }
    }

    func allViews() -> AnyCollection<View> {
        let viewsCollection = self.views.values.lazy.flatMap { return $0 }
        return AnyCollection(viewsCollection)
    }

    mutating func removeAll() {
        views.removeAll()
    }
}

extension ViewReuseCollection: Collection {

    typealias Index = DictionaryType.Index
    typealias Element = DictionaryType.Element

    var startIndex: Index { return self.views.startIndex }
    var endIndex: Index { return self.views.endIndex }

    subscript(index: Index) -> Iterator.Element {
        get {
            return self.views[index]

        }
    }

    func index(after i: Index) -> Index {
        return self.views.index(after: i)
    }
}

