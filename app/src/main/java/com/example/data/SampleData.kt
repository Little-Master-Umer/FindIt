package com.example.data

import com.example.model.ItemCategory
import com.example.model.ItemReport
import com.example.model.ReportStatus
import com.example.model.ReportType
import com.example.model.User

object SampleData {
    val users = listOf(
        User(
            id = "user_ali",
            name = "Ali Khan",
            studentId = "FA21-BCS-042",
            phone = "+92 300 1234567",
            avatarInitials = "AK"
        ),
        User(
            id = "user_ahmed",
            name = "Ahmed Raza",
            studentId = "SP22-BSE-110",
            phone = "+92 321 7654321",
            avatarInitials = "AR"
        ),
        User(
            id = "user_fatima",
            name = "Fatima Noor",
            studentId = "FA23-BEE-019",
            phone = "+92 333 9988776",
            avatarInitials = "FN"
        )
    )

    val defaultUser = users[0] // Ali Khan

    val initialReports = listOf(
        ItemReport(
            id = "REP-1001",
            itemName = "Brown Leather Wallet",
            type = ReportType.LOST,
            category = ItemCategory.CARDS,
            location = "Central Library, 2nd Floor Study Desk 14",
            date = "Oct 27, 2026",
            description = "Dark brown leather bifold wallet with university ID card, ATM card, and campus access card. Lost during evening study session.",
            ownerId = "user_ali",
            ownerName = "Ali Khan",
            status = ReportStatus.ACTIVE
        ),
        ItemReport(
            id = "REP-1002",
            itemName = "University Student ID Card",
            type = ReportType.FOUND,
            category = ItemCategory.CARDS,
            location = "Student Center Cafeteria Counter",
            date = "Oct 26, 2026",
            description = "Found near table 6 next to the beverage dispenser. Cardholder name says Bilal Tariq, Dept of Electrical Engineering.",
            ownerId = "user_ahmed",
            ownerName = "Ahmed Raza",
            status = ReportStatus.ACTIVE
        ),
        ItemReport(
            id = "REP-1003",
            itemName = "AirPods Pro in Navy Case",
            type = ReportType.LOST,
            category = ItemCategory.ELECTRONICS,
            location = "Engineering Block A, Room 104",
            date = "Oct 25, 2026",
            description = "Apple AirPods Pro with dark blue silicon protective sleeve and small astronaut keychain ring. Left on desk row 3.",
            ownerId = "user_fatima",
            ownerName = "Fatima Noor",
            status = ReportStatus.FINDER_FOUND,
            finderName = "Ahmed Raza",
            finderPhone = "+92 321 7654321",
            foundLocation = "Engineering Dept Office",
            finderMessage = "Handed over to Mr. Usama at the front desk for safe keeping. You can collect it with your student ID.",
            finderDate = "Oct 26, 2026"
        ),
        ItemReport(
            id = "REP-1004",
            itemName = "Casio FX-991EX Calculator",
            type = ReportType.LOST,
            category = ItemCategory.ELECTRONICS,
            location = "Math Building Exam Hall B",
            date = "Oct 24, 2026",
            description = "Scientific calculator with silver faceplate and black slip case. Left after calculus midterm test.",
            ownerId = "user_ali",
            ownerName = "Ali Khan",
            status = ReportStatus.RECOVERED,
            finderName = "Zain Malik",
            finderPhone = "+92 345 1122334",
            foundLocation = "Exam Control Room Desk",
            finderMessage = "Submitted to exam staff right after test concluded.",
            finderDate = "Oct 24, 2026"
        ),
        ItemReport(
            id = "REP-1005",
            itemName = "Dorm Keys on Red Lanyard",
            type = ReportType.FOUND,
            category = ItemCategory.OTHER,
            location = "Campus Shuttle Stop 2",
            date = "Oct 26, 2026",
            description = "Set of three silver keys with a red nylon university lanyard and gym membership barcode fob. Found on bench.",
            ownerId = "user_ahmed",
            ownerName = "Ahmed Raza",
            status = ReportStatus.ACTIVE
        ),
        ItemReport(
            id = "REP-1006",
            itemName = "Silver Watch with Mesh Strap",
            type = ReportType.LOST,
            category = ItemCategory.ACCESSORIES,
            location = "Sports Complex Gymnasium Lockers",
            date = "Oct 23, 2026",
            description = "Minimalist analog watch with silver magnetic mesh strap. Left on the locker room bench before basketball practice.",
            ownerId = "user_ali",
            ownerName = "Ali Khan",
            status = ReportStatus.ACTIVE
        )
    )
}
