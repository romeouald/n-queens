//
//  Store.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import SwiftData

private extension ModelContainer {
    static func make(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            BestTimeModel.self,
        ])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        return try ModelContainer(for: schema, configurations: config)
    }
}
    
extension ModelContext {
    static var live: ModelContext? {
        guard let container = try? ModelContainer.make() else {
            return nil
        }
        
        return ModelContext(container)
    }
    
    static var preview: ModelContext? {
        guard let container = try? ModelContainer.make(inMemory: true) else {
            return nil
        }
        
        return ModelContext(container)
    }
}
