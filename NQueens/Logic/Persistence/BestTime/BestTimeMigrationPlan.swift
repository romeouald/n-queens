//
//  BestTimeMigrationPlan.swift
//  NQueens
//
//  Created by Romuald Szauer on 13/05/2026.
//

import SwiftData

enum BestTimeMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [
        BestTimeSchemaV0.self,
        BestTimeSchemaV1.self,
        BestTimeSchemaV2.self
    ]

    static let stages: [MigrationStage] = [
        migrateV0toV1,
        migrateV1toV2
    ]

}

private extension BestTimeMigrationPlan {
    static let migrateV0toV1 = MigrationStage.custom(
        fromVersion: BestTimeSchemaV0.self,
        toVersion: BestTimeSchemaV1.self) { _ in
        } didMigrate: { context in
            let records = try context.fetch(FetchDescriptor<BestTimeSchemaV1.BestTimeModel>())
            for record in records {
                if record.key == nil {
                    record.key = BestTimeSchemaV1.BestTimeModel.key(game: .nQueens, boardSize: record.boardSize)
                }
            }
            try context.save()
        }

    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: BestTimeSchemaV1.self,
        toVersion: BestTimeSchemaV2.self
    )
}
