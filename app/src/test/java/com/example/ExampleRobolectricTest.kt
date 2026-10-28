package com.example

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import com.example.data.ReportRepository
import com.example.data.SampleData
import com.example.model.ItemCategory
import com.example.model.ReportStatus
import com.example.model.ReportType
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class ExampleRobolectricTest {

    @Test
    fun `read string from context matches FindIt app name`() {
        val context = ApplicationProvider.getApplicationContext<Context>()
        val appName = context.getString(R.string.app_name)
        assertEquals("FindIt", appName)
    }

    @Test
    fun `verify Ali loses wallet and Ahmed submits finder details then Ali marks as recovered`() {
        val repository = ReportRepository()

        // 1. Initial user is Ali Khan
        assertEquals("user_ali", repository.currentUser.value.id)

        // 2. Ali creates a lost item report
        val lostReport = repository.createReport(
            itemName = "Black Leather Wallet",
            type = ReportType.LOST,
            category = ItemCategory.CARDS,
            location = "Library 2nd Floor",
            date = "Oct 28, 2026",
            description = "Contains campus card and gym pass"
        )
        assertNotNull(lostReport)
        assertEquals(ReportStatus.ACTIVE, lostReport.status)
        assertEquals("user_ali", lostReport.ownerId)

        // 3. Switch to Ahmed who finds the wallet
        val ahmed = SampleData.users.first { it.id == "user_ahmed" }
        repository.switchUser(ahmed)
        assertEquals("user_ahmed", repository.currentUser.value.id)

        // 4. Ahmed submits finder details
        val finderResult = repository.submitFinderDetails(
            reportId = lostReport.id,
            finderName = "Ahmed Raza",
            finderPhone = "+92 321 7654321",
            foundLocation = "Library Help Desk",
            finderMessage = "Handed to the receptionist"
        )
        assertTrue(finderResult.isSuccess)
        val updatedReport = repository.getReportById(lostReport.id)
        assertNotNull(updatedReport)
        assertEquals(ReportStatus.FINDER_FOUND, updatedReport?.status)
        assertEquals("Ahmed Raza", updatedReport?.finderName)

        // 5. Duplicate finder submission must be rejected
        val duplicateResult = repository.submitFinderDetails(
            reportId = lostReport.id,
            finderName = "Another Person",
            finderPhone = "1234567",
            foundLocation = "Anywhere",
            finderMessage = ""
        )
        assertFalse(duplicateResult.isSuccess)

        // 6. Ahmed (non-owner) cannot mark as recovered
        val nonOwnerRecoverResult = repository.markAsRecovered(lostReport.id)
        assertFalse(nonOwnerRecoverResult.isSuccess)

        // 7. Switch back to Ali (original owner)
        val ali = SampleData.users.first { it.id == "user_ali" }
        repository.switchUser(ali)

        // 8. Ali marks as recovered
        val ownerRecoverResult = repository.markAsRecovered(lostReport.id)
        assertTrue(ownerRecoverResult.isSuccess)

        val finalReport = repository.getReportById(lostReport.id)
        assertEquals(ReportStatus.RECOVERED, finalReport?.status)
    }
}
