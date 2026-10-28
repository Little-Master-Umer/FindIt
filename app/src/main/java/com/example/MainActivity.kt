package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Assignment
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.outlined.Assignment
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.ReportRepository
import com.example.model.ItemCategory
import com.example.model.ReportType
import com.example.ui.components.UserSwitcherDialog
import com.example.ui.screens.CreateReportScreen
import com.example.ui.screens.FinderDetailsScreen
import com.example.ui.screens.HomeScreen
import com.example.ui.screens.ItemDetailsScreen
import com.example.ui.screens.MyReportsScreen
import com.example.ui.screens.SearchScreen
import com.example.ui.screens.SplashScreen
import com.example.ui.theme.MyApplicationTheme
import com.example.ui.theme.TealBackground
import com.example.ui.theme.TealPrimary
import com.example.ui.theme.TealSurfaceVariant
import com.example.ui.theme.TextSecondary
import kotlinx.coroutines.launch

sealed class Screen {
    object Splash : Screen()
    object Home : Screen()
    data class Search(val preselectedCategory: ItemCategory? = null) : Screen()
    object MyReports : Screen()
    data class CreateReport(val initialType: ReportType) : Screen()
    data class ItemDetails(val reportId: String) : Screen()
    data class FinderDetails(val reportId: String) : Screen()
}

class MainActivity : ComponentActivity() {
    private val repository = ReportRepository()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MyApplicationTheme {
                FindItApp(repository = repository)
            }
        }
    }
}

@Composable
fun FindItApp(repository: ReportRepository) {
    val currentUser by repository.currentUser.collectAsState()
    val reports by repository.reports.collectAsState()

    var currentScreen by remember { mutableStateOf<Screen>(Screen.Home) }
    var screenStack by remember { mutableStateOf(listOf<Screen>(Screen.Home)) }
    var showUserSwitcher by remember { mutableStateOf(false) }

    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()

    fun navigateTo(screen: Screen) {
        screenStack = screenStack + screen
        currentScreen = screen
    }

    fun navigateBack() {
        if (screenStack.size > 1) {
            val newStack = screenStack.dropLast(1)
            screenStack = newStack
            currentScreen = newStack.last()
        } else {
            currentScreen = Screen.Home
        }
    }

    // Whether bottom navigation bar should be visible
    val isMainTab = currentScreen is Screen.Home ||
            currentScreen is Screen.Search ||
            currentScreen is Screen.MyReports

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        snackbarHost = { SnackbarHost(hostState = snackbarHostState) },
        bottomBar = {
            if (isMainTab) {
                NavigationBar(
                    containerColor = Color.White,
                    tonalElevation = 6.dp,
                    modifier = Modifier.navigationBarsPadding().testTag("bottom_nav_bar")
                ) {
                    val isHome = currentScreen is Screen.Home
                    val isSearch = currentScreen is Screen.Search
                    val isMyReports = currentScreen is Screen.MyReports

                    NavigationBarItem(
                        selected = isHome,
                        onClick = {
                            if (!isHome) {
                                currentScreen = Screen.Home
                                screenStack = listOf(Screen.Home)
                            }
                        },
                        icon = {
                            Icon(
                                imageVector = if (isHome) Icons.Filled.Home else Icons.Outlined.Home,
                                contentDescription = "Home"
                            )
                        },
                        label = {
                            Text(
                                "Home",
                                fontSize = 12.sp,
                                fontWeight = if (isHome) FontWeight.Bold else FontWeight.Normal
                            )
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = TealPrimary,
                            selectedTextColor = TealPrimary,
                            indicatorColor = TealSurfaceVariant,
                            unselectedIconColor = TextSecondary,
                            unselectedTextColor = TextSecondary
                        ),
                        modifier = Modifier.testTag("nav_tab_home")
                    )

                    NavigationBarItem(
                        selected = isSearch,
                        onClick = {
                            if (!isSearch) {
                                currentScreen = Screen.Search()
                                screenStack = listOf(Screen.Home, Screen.Search())
                            }
                        },
                        icon = {
                            Icon(
                                imageVector = if (isSearch) Icons.Filled.Search else Icons.Outlined.Search,
                                contentDescription = "Search"
                            )
                        },
                        label = {
                            Text(
                                "Search",
                                fontSize = 12.sp,
                                fontWeight = if (isSearch) FontWeight.Bold else FontWeight.Normal
                            )
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = TealPrimary,
                            selectedTextColor = TealPrimary,
                            indicatorColor = TealSurfaceVariant,
                            unselectedIconColor = TextSecondary,
                            unselectedTextColor = TextSecondary
                        ),
                        modifier = Modifier.testTag("nav_tab_search")
                    )

                    NavigationBarItem(
                        selected = isMyReports,
                        onClick = {
                            if (!isMyReports) {
                                currentScreen = Screen.MyReports
                                screenStack = listOf(Screen.Home, Screen.MyReports)
                            }
                        },
                        icon = {
                            Icon(
                                imageVector = if (isMyReports) Icons.Filled.Assignment else Icons.Outlined.Assignment,
                                contentDescription = "My Reports"
                            )
                        },
                        label = {
                            Text(
                                "My Reports",
                                fontSize = 12.sp,
                                fontWeight = if (isMyReports) FontWeight.Bold else FontWeight.Normal
                            )
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = TealPrimary,
                            selectedTextColor = TealPrimary,
                            indicatorColor = TealSurfaceVariant,
                            unselectedIconColor = TextSecondary,
                            unselectedTextColor = TextSecondary
                        ),
                        modifier = Modifier.testTag("nav_tab_my_reports")
                    )
                }
            }
        }
    ) { innerPadding ->
        when (val screen = currentScreen) {
            is Screen.Splash -> {
                SplashScreen(
                    onGetStarted = {
                        currentScreen = Screen.Home
                        screenStack = listOf(Screen.Home)
                    },
                    modifier = Modifier.padding(innerPadding)
                )
            }

            is Screen.Home -> {
                HomeScreen(
                    currentUser = currentUser,
                    reports = reports,
                    onOpenReportForm = { type ->
                        navigateTo(Screen.CreateReport(type))
                    },
                    onCategoryClick = { category ->
                        navigateTo(Screen.Search(preselectedCategory = category))
                    },
                    onSearchClick = {
                        navigateTo(Screen.Search())
                    },
                    onReportClick = { report ->
                        navigateTo(Screen.ItemDetails(report.id))
                    },
                    onSwitchUserClick = { showUserSwitcher = true },
                    onSeeAllClick = {
                        navigateTo(Screen.Search())
                    },
                    modifier = Modifier.padding(innerPadding)
                )
            }

            is Screen.Search -> {
                BackHandler {
                    currentScreen = Screen.Home
                    screenStack = listOf(Screen.Home)
                }
                SearchScreen(
                    reports = reports,
                    initialCategory = screen.preselectedCategory,
                    onReportClick = { report ->
                        navigateTo(Screen.ItemDetails(report.id))
                    },
                    modifier = Modifier.padding(innerPadding)
                )
            }

            is Screen.MyReports -> {
                BackHandler {
                    currentScreen = Screen.Home
                    screenStack = listOf(Screen.Home)
                }
                MyReportsScreen(
                    currentUser = currentUser,
                    allReports = reports,
                    onReportClick = { report ->
                        navigateTo(Screen.ItemDetails(report.id))
                    },
                    onCreateReportClick = {
                        navigateTo(Screen.CreateReport(ReportType.LOST))
                    },
                    onSwitchUserClick = { showUserSwitcher = true },
                    onMarkRecovered = { reportId ->
                        val res = repository.markAsRecovered(reportId)
                        if (res.isSuccess) {
                            coroutineScope.launch {
                                snackbarHostState.showSnackbar("Item marked as Recovered! 🎉")
                            }
                        }
                    },
                    modifier = Modifier.padding(innerPadding)
                )
            }

            is Screen.CreateReport -> {
                BackHandler { navigateBack() }
                CreateReportScreen(
                    initialType = screen.initialType,
                    currentUser = currentUser,
                    onSubmitReport = { itemName, type, category, location, date, description ->
                        val created = repository.createReport(
                            itemName = itemName,
                            type = type,
                            category = category,
                            location = location,
                            date = date,
                            description = description
                        )
                        coroutineScope.launch {
                            snackbarHostState.showSnackbar("${created.type.displayName} report for '${created.itemName}' published successfully!")
                        }
                        navigateBack()
                    },
                    onBackClick = { navigateBack() },
                    modifier = Modifier.padding(innerPadding)
                )
            }

            is Screen.ItemDetails -> {
                BackHandler { navigateBack() }
                val targetReport = reports.find { it.id == screen.reportId }
                if (targetReport != null) {
                    ItemDetailsScreen(
                        report = targetReport,
                        currentUser = currentUser,
                        onBackClick = { navigateBack() },
                        onFoundThisClick = { reportId ->
                            navigateTo(Screen.FinderDetails(reportId))
                        },
                        onMarkRecovered = { reportId ->
                            val res = repository.markAsRecovered(reportId)
                            if (res.isSuccess) {
                                coroutineScope.launch {
                                    snackbarHostState.showSnackbar("Marked as recovered! 🎉")
                                }
                            }
                        },
                        modifier = Modifier.padding(innerPadding)
                    )
                } else {
                    navigateBack()
                }
            }

            is Screen.FinderDetails -> {
                BackHandler { navigateBack() }
                val targetReport = reports.find { it.id == screen.reportId }
                if (targetReport != null) {
                    FinderDetailsScreen(
                        report = targetReport,
                        currentUser = currentUser,
                        onSubmitFinderDetails = { reportId, finderName, finderPhone, location, msg ->
                            val res = repository.submitFinderDetails(
                                reportId = reportId,
                                finderName = finderName,
                                finderPhone = finderPhone,
                                foundLocation = location,
                                finderMessage = msg
                            )
                            if (res.isSuccess) {
                                coroutineScope.launch {
                                    snackbarHostState.showSnackbar("Finder details sent to ${targetReport.ownerName}!")
                                }
                                navigateBack()
                            } else {
                                coroutineScope.launch {
                                    snackbarHostState.showSnackbar(
                                        res.exceptionOrNull()?.message ?: "Submission failed"
                                    )
                                }
                            }
                        },
                        onBackClick = { navigateBack() },
                        modifier = Modifier.padding(innerPadding)
                    )
                } else {
                    navigateBack()
                }
            }
        }
    }

    if (showUserSwitcher) {
        UserSwitcherDialog(
            currentUser = currentUser,
            onUserSelected = { selectedUser ->
                repository.switchUser(selectedUser)
                coroutineScope.launch {
                    snackbarHostState.showSnackbar("Switched profile to ${selectedUser.name}")
                }
            },
            onDismiss = { showUserSwitcher = false }
        )
    }
}
