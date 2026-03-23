//
//  Store.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import SwiftData
import os

private extension ModelContainer {
    static func make(inMemory: Bool = false) -> ModelContainer? {
        let schema = Schema([
            BestTimeModel.self,
        ])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            os.Logger(subsystem: "PersistentStore", category: "ModelContainer")
                .error("Failed to initialize ModelContainer")
            return nil
        }        
    }
}
    
extension ModelContext {
    static var live: ModelContext? {
        guard let container = ModelContainer.make() else { return nil }
        return ModelContext(container)
    }
    
    static var preview: ModelContext? {
        guard let container = ModelContainer.make(inMemory: true) else { return nil }
        return ModelContext(container)
    }
    
    static var test: ModelContext? {
        guard let container = ModelContainer.make(inMemory: true) else { return nil }
        return ModelContext(container)
    }
}
