package com.example.model

enum class ReportType(val displayName: String) {
    LOST("Lost"),
    FOUND("Found")
}

enum class ItemCategory(val displayName: String) {
    ELECTRONICS("Electronics"),
    CARDS("Cards"),
    ACCESSORIES("Accessories"),
    OTHER("Other")
}

enum class ReportStatus(val displayName: String) {
    ACTIVE("Active"),
    FINDER_FOUND("Finder Found"),
    RECOVERED("Recovered")
}

data class User(
    val id: String,
    val name: String,
    val studentId: String,
    val phone: String,
    val avatarInitials: String
)

data class ItemReport(
    val id: String,
    val itemName: String,
    val type: ReportType,
    val category: ItemCategory,
    val location: String,
    val date: String,
    val description: String,
    val ownerId: String,
    val ownerName: String,
    val status: ReportStatus = ReportStatus.ACTIVE,
    val finderName: String? = null,
    val finderPhone: String? = null,
    val foundLocation: String? = null,
    val finderMessage: String? = null,
    val finderDate: String? = null
)
