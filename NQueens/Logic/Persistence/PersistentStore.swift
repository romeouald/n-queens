//
//  Store.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import SwiftData

enum PersistentStore {
    
    enum Container {
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
    
    enum Context {
        static var live: ModelContext {
            get throws {
                return ModelContext(try PersistentStore.Container.make(inMemory: true))
            }
        }

        static var preview: ModelContext {
            get throws {
                return ModelContext(try PersistentStore.Container.make(inMemory: true))
            }
        }
    }
    
}
