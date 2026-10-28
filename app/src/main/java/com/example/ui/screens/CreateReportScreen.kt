package com.example.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Inventory
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.model.ItemCategory
import com.example.model.ItemReport
import com.example.model.ReportType
import com.example.model.User
import com.example.ui.components.CategoryChip
import com.example.ui.theme.TealBackground
import com.example.ui.theme.TealPrimary
import com.example.ui.theme.TealPrimaryDark
import com.example.ui.theme.TealSurfaceVariant
import com.example.ui.theme.TextMuted
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import com.example.ui.theme.TypeLostBg
import com.example.ui.theme.TypeLostText
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CreateReportScreen(
    initialType: ReportType = ReportType.LOST,
    currentUser: User,
    onSubmitReport: (itemName: String, type: ReportType, category: ItemCategory, location: String, date: String, description: String) -> Unit,
    onBackClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    var reportType by remember { mutableStateOf(initialType) }
    var itemName by remember { mutableStateOf("") }
    var selectedCategory by remember { mutableStateOf(ItemCategory.ELECTRONICS) }
    var location by remember { mutableStateOf("") }
    var date by remember {
        mutableStateOf(SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(Date()))
    }
    var description by remember { mutableStateOf("") }

    // Validation error states
    var itemNameError by remember { mutableStateOf<String?>(null) }
    var locationError by remember { mutableStateOf<String?>(null) }
    var descriptionError by remember { mutableStateOf<String?>(null) }

    fun validateAndSubmit() {
        var isValid = true

        if (itemName.trim().isEmpty()) {
            itemNameError = "Please enter an item name"
            isValid = false
        } else {
            itemNameError = null
        }

        if (location.trim().isEmpty()) {
            locationError = "Please specify the campus location"
            isValid = false
        } else {
            locationError = null
        }

        if (description.trim().isEmpty()) {
            descriptionError = "Please provide details to help identify the item"
            isValid = false
        } else if (description.trim().length < 10) {
            descriptionError = "Description should be at least 10 characters"
            isValid = false
        } else {
            descriptionError = null
        }

        if (isValid) {
            onSubmitReport(
                itemName.trim(),
                reportType,
                selectedCategory,
                location.trim(),
                date.trim(),
                description.trim()
            )
        }
    }

    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = if (reportType == ReportType.LOST) "Report Lost Item" else "Report Found Item",
                        fontWeight = FontWeight.Bold,
                        fontSize = 19.sp,
                        color = TealPrimaryDark
                    )
                },
                navigationIcon = {
                    IconButton(
                        onClick = onBackClick,
                        modifier = Modifier.testTag("create_report_back_btn")
                    ) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = TealPrimary
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = TealBackground
                )
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(TealBackground)
                .padding(innerPadding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Owner Info Card
            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(
                    containerColor = TealSurfaceVariant.copy(alpha = 0.5f)
                ),
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier.padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Submitting as: ",
                        fontSize = 13.sp,
                        color = TextSecondary
                    )
                    Text(
                        text = "${currentUser.name} (${currentUser.studentId})",
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Bold,
                        color = TealPrimaryDark
                    )
                }
            }

            // Report Type Toggle: Lost vs Found
            Text(
                text = "Report Type",
                fontWeight = FontWeight.SemiBold,
                fontSize = 14.sp,
                color = TextPrimary
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                // Lost Button
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .clip(RoundedCornerShape(12.dp))
                        .background(if (reportType == ReportType.LOST) TypeLostBg else Color.White)
                        .border(
                            width = if (reportType == ReportType.LOST) 2.dp else 1.dp,
                            color = if (reportType == ReportType.LOST) TypeLostText else Color(0xFFE5E7EB),
                            shape = RoundedCornerShape(12.dp)
                        )
                        .clickable { reportType = ReportType.LOST }
                        .padding(vertical = 12.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "Lost Item",
                        fontWeight = FontWeight.Bold,
                        color = if (reportType == ReportType.LOST) TypeLostText else TextSecondary,
                        fontSize = 14.sp
                    )
                }

                // Found Button
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .clip(RoundedCornerShape(12.dp))
                        .background(if (reportType == ReportType.FOUND) TealSurfaceVariant else Color.White)
                        .border(
                            width = if (reportType == ReportType.FOUND) 2.dp else 1.dp,
                            color = if (reportType == ReportType.FOUND) TealPrimary else Color(0xFFE5E7EB),
                            shape = RoundedCornerShape(12.dp)
                        )
                        .clickable { reportType = ReportType.FOUND }
                        .padding(vertical = 12.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "Found Item",
                        fontWeight = FontWeight.Bold,
                        color = if (reportType == ReportType.FOUND) TealPrimaryDark else TextSecondary,
                        fontSize = 14.sp
                    )
                }
            }

            // Item Name Field
            Column {
                Text(
                    text = "Item Name *",
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 14.sp,
                    color = TextPrimary
                )
                Spacer(modifier = Modifier.height(6.dp))
                OutlinedTextField(
                    value = itemName,
                    onValueChange = {
                        itemName = it
                        if (itemNameError != null) itemNameError = null
                    },
                    placeholder = {
                        Text(
                            text = if (reportType == ReportType.LOST) "e.g. Leather Wallet, Blue Backpack" else "e.g. Student ID Card, Casio Calculator",
                            color = TextMuted,
                            fontSize = 14.sp
                        )
                    },
                    leadingIcon = {
                        Icon(
                            imageVector = Icons.Default.Inventory,
                            contentDescription = null,
                            tint = TealPrimary
                        )
                    },
                    isError = itemNameError != null,
                    supportingText = itemNameError?.let { { Text(it, color = MaterialTheme.colorScheme.error) } },
                    singleLine = true,
                    shape = RoundedCornerShape(12.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedContainerColor = Color.White,
                        unfocusedContainerColor = Color.White
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("input_item_name")
                )
            }

            // Category Selector
            Column {
                Text(
                    text = "Category *",
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 14.sp,
                    color = TextPrimary
                )
                Spacer(modifier = Modifier.height(8.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    ItemCategory.values().forEach { category ->
                        CategoryChip(
                            category = category,
                            isSelected = selectedCategory == category,
                            onClick = { selectedCategory = category },
                            modifier = Modifier.testTag("create_cat_${category.name.lowercase()}")
                        )
                    }
                }
            }

            // Campus Location Field
            Column {
                Text(
                    text = "Campus Location *",
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 14.sp,
                    color = TextPrimary
                )
                Spacer(modifier = Modifier.height(6.dp))
                OutlinedTextField(
                    value = location,
                    onValueChange = {
                        location = it
                        if (locationError != null) locationError = null
                    },
                    placeholder = {
                        Text(
                            text = "e.g. Central Library 2nd Floor, Cafeteria Table 4",
                            color = TextMuted,
                            fontSize = 14.sp
                        )
                    },
                    leadingIcon = {
                        Icon(
                            imageVector = Icons.Default.LocationOn,
                            contentDescription = null,
                            tint = TealPrimary
                        )
                    },
                    isError = locationError != null,
                    supportingText = locationError?.let { { Text(it, color = MaterialTheme.colorScheme.error) } },
                    singleLine = true,
                    shape = RoundedCornerShape(12.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedContainerColor = Color.White,
                        unfocusedContainerColor = Color.White
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("input_location")
                )
            }

            // Date Field
            Column {
                Text(
                    text = "Date *",
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 14.sp,
                    color = TextPrimary
                )
                Spacer(modifier = Modifier.height(6.dp))
                OutlinedTextField(
                    value = date,
                    onValueChange = { date = it },
                    placeholder = { Text("e.g. Oct 28, 2026", color = TextMuted, fontSize = 14.sp) },
                    leadingIcon = {
                        Icon(
                            imageVector = Icons.Default.CalendarToday,
                            contentDescription = null,
                            tint = TealPrimary
                        )
                    },
                    singleLine = true,
                    shape = RoundedCornerShape(12.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedContainerColor = Color.White,
                        unfocusedContainerColor = Color.White
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("input_date")
                )
            }

            // Description Field
            Column {
                Text(
                    text = "Detailed Description *",
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 14.sp,
                    color = TextPrimary
                )
                Spacer(modifier = Modifier.height(6.dp))
                OutlinedTextField(
                    value = description,
                    onValueChange = {
                        description = it
                        if (descriptionError != null) descriptionError = null
                    },
                    placeholder = {
                        Text(
                            text = "Describe colors, brand, serial numbers, unique scratches, contents, or key characteristics...",
                            color = TextMuted,
                            fontSize = 14.sp
                        )
                    },
                    leadingIcon = {
                        Icon(
                            imageVector = Icons.Default.Description,
                            contentDescription = null,
                            tint = TealPrimary
                        )
                    },
                    minLines = 3,
                    maxLines = 5,
                    isError = descriptionError != null,
                    supportingText = descriptionError?.let { { Text(it, color = MaterialTheme.colorScheme.error) } },
                    shape = RoundedCornerShape(12.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedContainerColor = Color.White,
                        unfocusedContainerColor = Color.White
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("input_description")
                )
            }

            Spacer(modifier = Modifier.height(10.dp))

            // Submit Button
            Button(
                onClick = { validateAndSubmit() },
                shape = RoundedCornerShape(14.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = TealPrimary,
                    contentColor = Color.White
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(52.dp)
                    .testTag("submit_report_button")
            ) {
                Text(
                    text = if (reportType == ReportType.LOST) "Publish Lost Report" else "Publish Found Report",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold
                )
            }
        }
    }
}
