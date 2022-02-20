//
//  CoreDataManager.swift
//  Meister-Search
//
//  Created by Artsem Lemiasheuski on 19.02.22.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private let entity = "TaskEntity"

    func storeTasks(tasks: [Task]) {
        let context = getContext()

        for task in tasks {
            if (taskExists(task: task)) {
                continue
            }

            if let taskEntity = NSEntityDescription.insertNewObject(forEntityName: entity, into: context) as? TaskEntity {
                taskEntity.id = Int32(task.id ?? 0)
                taskEntity.name = task.name
                taskEntity.sequence = Int32(task.sequence ?? 0)
                taskEntity.priority = task.priority
                taskEntity.status = Int32(task.status ?? 0)
                taskEntity.taskRepeat = task.taskRepeat
                taskEntity.notes = task.notes
                taskEntity.flagged = task.flagged
                taskEntity.assignedToID = task.assignedToID
                taskEntity.trackedTime = Int32(task.trackedTime ?? 0)
                taskEntity.createdByID = Int32(task.createdByID ?? 0)
                taskEntity.createdByOrigin = task.createdByOrigin
                taskEntity.reminder = task.reminder
                taskEntity.createdAt = task.createdAt
                taskEntity.updatedAt = task.updatedAt
                taskEntity.sectionID = Int32(task.sectionID ?? 0)
                taskEntity.taskToken = task.taskToken
                taskEntity.commentsCount = Int32(task.commentsCount ?? 0)
                taskEntity.statusChangedByID = Int32(task.statusChangedByID ?? 0)
                taskEntity.due = task.due
                taskEntity.attachmentsCount = Int32(task.attachmentsCount ?? 0)
                taskEntity.closedClItemsCount = Int32(task.closedClItemsCount ?? 0)
                taskEntity.totalClItemsCount = Int32(task.totalClItemsCount ?? 0)
                taskEntity.statusUpdatedAt = task.statusUpdatedAt
                taskEntity.metaInformation = task.metaInformation
                taskEntity.attachmentID = task.attachmentID
                taskEntity.completedAt = task.completedAt
            }
        }

        do {
            try context.save()
        } catch {
            fatalError("Error while saving")
        }
    }

    func getTasks(name: String, status: [Int]) -> [Task] {
        let context = getContext()

        do {
            let fetchRequest = NSFetchRequest<TaskEntity>(entityName: entity)
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@ AND status IN %@", name, status)

            return try context.fetch(fetchRequest).map(Task.init)
        } catch {
            fatalError("Error while fetching tasks from the Core Data: \(error)")
        }
    }


    private func getAllTasks() -> [Task] {
        let context = getContext()

        do {
            let fetchRequest = NSFetchRequest<TaskEntity>(entityName: entity)

            return try context.fetch(fetchRequest).map(Task.init)
        } catch {
            fatalError("Error while fetching tasks from the Core Data: \(error)")
        }
    }

    private func taskExists(task: Task) -> Bool {
        return getAllTasks().first { $0.id == task.id } != nil ? true : false
    }

    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        return appDelegate.persistentContainer.viewContext
    }
}
