//
//  Test.swift
//  Meister-Search
//
//  Created by Artsem Lemiasheuski on 13.02.22.
//

import Foundation

// MARK: - Data
struct Data: Codable {
    let results: Results?
    let paging: Paging?
}

// MARK: - Paging
struct Paging: Codable {
    let totalResults, totalPages, currentPage, resultsPerPage: Int

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case resultsPerPage = "results_per_page"
    }
}

// MARK: - Results
struct Results: Codable {
    let tasks: [Task]?
    let sections: [Section]?
    let projects: [Project]?
}

// MARK: - Project
struct Project: Codable {
    let id: Int?
    let type: String?
    let name: String
    let status: Int?
    let notes: String?
    let createdAt, updatedAt, color, token: String?
    let shareMode: Int?
    let mailToken: String?
    let tasksActiveCount, tasksArchiveCount, tasksTrashCount, tasksCompleteCount: Int?
    let shareToken: String?
    let shareTokenEnabled: Bool?
    let teamID: Int?
    let rolesEnabled: Bool?
    let creatorID, creatorName, trashedAt: String?
}

// MARK: - Section
struct Section: Codable {
    let id: Int?
    let name: String?
    let indicator, sequence, projectID: Int?
    let createdAt, updatedAt: String?
    let status: Int?
    let color: String?
    let sectionDescription, limit: String?
    let objectActionsCount, recurringActionsCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, indicator, sequence
        case projectID = "project_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status, color
        case sectionDescription = "description"
        case limit
        case objectActionsCount = "object_actions_count"
        case recurringActionsCount = "recurring_actions_count"
    }
}

// MARK: - Task
struct Task: Codable {
    let id: Int?
    let name: String?
    let sequence: Int?
    let priority: String?
    let status: Int?
    let taskRepeat, notes, flagged, assignedToID: String?
    let trackedTime, createdByID: Int?
    let createdByOrigin: String?
    let reminder: String?
    let createdAt, updatedAt: String?
    let sectionID: Int?
    let taskToken: String?
    let commentsCount, statusChangedByID: Int?
    let due: String?
    let attachmentsCount, closedClItemsCount, totalClItemsCount: Int?
    let statusUpdatedAt: String?
    let metaInformation, attachmentID: String?
    let completedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, sequence, priority, status
        case taskRepeat = "repeat"
        case notes, flagged
        case assignedToID = "assigned_to_id"
        case trackedTime = "tracked_time"
        case createdByID = "created_by_id"
        case createdByOrigin = "created_by_origin"
        case reminder
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sectionID = "section_id"
        case taskToken = "token"
        case commentsCount = "comments_count"
        case statusChangedByID = "status_changed_by_id"
        case due
        case attachmentsCount = "attachments_count"
        case closedClItemsCount = "closed_cl_items_count"
        case totalClItemsCount = "total_cl_items_count"
        case statusUpdatedAt = "status_updated_at"
        case metaInformation = "meta_information"
        case attachmentID = "attachment_id"
        case completedAt = "completed_at"
    }

    init(taskEntity: TaskEntity) {
        self.id = Int(taskEntity.id)
        self.name = taskEntity.name
        self.sequence = Int(taskEntity.sequence)
        self.priority = taskEntity.priority
        self.status = Int(taskEntity.status)
        self.taskRepeat = taskEntity.taskRepeat
        self.notes = taskEntity.notes
        self.flagged = taskEntity.flagged
        self.assignedToID = taskEntity.assignedToID
        self.trackedTime = Int(taskEntity.trackedTime)
        self.createdByID = Int(taskEntity.createdByID)
        self.createdByOrigin = taskEntity.createdByOrigin
        self.reminder = taskEntity.reminder
        self.createdAt = taskEntity.createdAt
        self.updatedAt = taskEntity.updatedAt
        self.sectionID = Int(taskEntity.sectionID)
        self.taskToken = taskEntity.taskToken
        self.commentsCount = Int(taskEntity.commentsCount)
        self.statusChangedByID = Int(taskEntity.statusChangedByID)
        self.due = taskEntity.due
        self.attachmentsCount = Int(taskEntity.attachmentsCount)
        self.closedClItemsCount = Int(taskEntity.closedClItemsCount)
        self.totalClItemsCount = Int(taskEntity.totalClItemsCount)
        self.statusUpdatedAt = taskEntity.statusUpdatedAt
        self.metaInformation = taskEntity.metaInformation
        self.attachmentID =  taskEntity.attachmentID
        self.completedAt = taskEntity.completedAt
    }
}
