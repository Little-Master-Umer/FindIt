package com.example.data

import com.example.model.ItemCategory
import com.example.model.ItemReport
import com.example.model.ReportStatus
import com.example.model.ReportType
import com.example.model.User
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class ReportRepository {
    private val _currentUser = MutableStateFlow(SampleData.defaultUser)
    val currentUser: StateFlow<User> = _currentUser.asStateFlow()

    private val _reports = MutableStateFlow(SampleData.initialReports)
    val reports: StateFlow<List<ItemReport>> = _reports.asStateFlow()

    private var nextReportIdNumber = 1007

    fun switchUser(user: User) {
        _currentUser.value = user
    }

    fun getReportById(id: String): ItemReport? {
        return _reports.value.find { it.id == id }
    }

    fun createReport(
        itemName: String,
        type: ReportType,
        category: ItemCategory,
        location: String,
        date: String,
        description: String
    ): ItemReport {
        val newId = "REP-${nextReportIdNumber++}"
        val user = _currentUser.value
        val report = ItemReport(
            id = newId,
            itemName = itemName.trim(),
            type = type,
            category = category,
            location = location.trim(),
            date = date.ifBlank {
                SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(Date())
            },
            description = description.trim(),
            ownerId = user.id,
            ownerName = user.name,
            status = ReportStatus.ACTIVE
        )

        _reports.update { currentList ->
            listOf(report) + currentList
        }
        return report
    }

    fun submitFinderDetails(
        reportId: String,
        finderName: String,
        finderPhone: String,
        foundLocation: String,
        finderMessage: String
    ): Result<ItemReport> {
        val target = getReportById(reportId)
            ?: return Result.failure(IllegalArgumentException("Report not found"))

        if (target.type != ReportType.LOST) {
            return Result.failure(IllegalStateException("Finder details can only be submitted for Lost items."))
        }

        if (target.status == ReportStatus.RECOVERED) {
            return Result.failure(IllegalStateException("This report is already recovered."))
        }

        if (target.status == ReportStatus.FINDER_FOUND) {
            return Result.failure(IllegalStateException("A finder has already submitted details for this item."))
        }

        val currentDateStr = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(Date())

        val updated = target.copy(
            status = ReportStatus.FINDER_FOUND,
            finderName = finderName.trim(),
            finderPhone = finderPhone.trim(),
            foundLocation = foundLocation.trim(),
            finderMessage = finderMessage.trim().ifEmpty { null },
            finderDate = currentDateStr
        )

        _reports.update { list ->
            list.map { if (it.id == reportId) updated else it }
        }
        return Result.success(updated)
    }

    fun markAsRecovered(reportId: String): Result<ItemReport> {
        val target = getReportById(reportId)
            ?: return Result.failure(IllegalArgumentException("Report not found"))

        val user = _currentUser.value
        if (target.ownerId != user.id) {
            return Result.failure(SecurityException("Only the original report owner can mark this as recovered."))
        }

        if (target.status == ReportStatus.RECOVERED) {
            return Result.failure(IllegalStateException("Item is already marked as recovered."))
        }

        val updated = target.copy(status = ReportStatus.RECOVERED)

        _reports.update { list ->
            list.map { if (it.id == reportId) updated else it }
        }
        return Result.success(updated)
    }

    fun resetDemoData() {
        nextReportIdNumber = 1007
        _currentUser.value = SampleData.defaultUser
        _reports.value = SampleData.initialReports
    }
}
