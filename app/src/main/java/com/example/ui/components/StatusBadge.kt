package com.example.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Help
import androidx.compose.material.icons.filled.PersonSearch
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.model.ReportStatus
import com.example.ui.theme.StatusActiveBg
import com.example.ui.theme.StatusActiveBorder
import com.example.ui.theme.StatusActiveText
import com.example.ui.theme.StatusFinderFoundBg
import com.example.ui.theme.StatusFinderFoundBorder
import com.example.ui.theme.StatusFinderFoundText
import com.example.ui.theme.StatusRecoveredBg
import com.example.ui.theme.StatusRecoveredBorder
import com.example.ui.theme.StatusRecoveredText

@Composable
fun StatusBadge(status: ReportStatus, modifier: Modifier = Modifier) {
    val (bgColor, textColor, borderColor, icon) = when (status) {
        ReportStatus.ACTIVE -> Quad(
            StatusActiveBg,
            StatusActiveText,
            StatusActiveBorder,
            Icons.Default.Help
        )
        ReportStatus.FINDER_FOUND -> Quad(
            StatusFinderFoundBg,
            StatusFinderFoundText,
            StatusFinderFoundBorder,
            Icons.Default.PersonSearch
        )
        ReportStatus.RECOVERED -> Quad(
            StatusRecoveredBg,
            StatusRecoveredText,
            StatusRecoveredBorder,
            Icons.Default.CheckCircle
        )
    }

    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = modifier
            .clip(RoundedCornerShape(12.dp))
            .background(bgColor)
            .border(1.dp, borderColor, RoundedCornerShape(12.dp))
            .padding(horizontal = 8.dp, vertical = 3.dp)
    ) {
        Icon(
            imageVector = icon,
            contentDescription = status.displayName,
            tint = textColor,
            modifier = Modifier.size(13.dp)
        )
        Spacer(modifier = Modifier.width(4.dp))
        Text(
            text = status.displayName,
            color = textColor,
            fontSize = 11.sp,
            fontWeight = FontWeight.SemiBold
        )
    }
}

private data class Quad<A, B, C, D>(val first: A, val second: B, val third: C, val fourth: D)
