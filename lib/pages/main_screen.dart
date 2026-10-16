part of '../main.dart';

// APP
// ============================================================

class BlueWayApp extends StatelessWidget {
  const BlueWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blue Way Transit',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Arial',
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: charcoal,
              brightness: Brightness.dark,
              surface: cardBg,
            ).copyWith(
              primary: primaryText,
              onPrimary: pageBg,
              secondary: mutedText,
              onSurface: primaryText,
              surface: cardBg,
              outline: borderColor,
            ),
        scaffoldBackgroundColor: pageBg,
        canvasColor: pageBg,
        dividerColor: borderColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: pageBg,
          foregroundColor: primaryText,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: borderColor),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          backgroundColor: cardBg,
          indicatorColor: subtleSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? primaryText
                  : mutedText,
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? primaryText
                  : mutedText,
              size: 22,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardBg,
          hintStyle: const TextStyle(color: mutedText),
          labelStyle: const TextStyle(color: mutedText),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryText, width: 1.5),
          ),
        ),
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}

// ============================================================
// MAIN NAVIGATION
// ============================================================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    blueWayStore.addListener(_storeChanged);
    if (!blueWayStore.ready) blueWayStore.load();
  }

  @override
  void dispose() {
    blueWayStore.removeListener(_storeChanged);
    super.dispose();
  }

  void _storeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!blueWayStore.ready) {
      return Scaffold(
        body: blueWayStore.loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 52,
                        color: mutedText,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Blue Way API unavailable',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        blueWayStore.loadError ??
                            'Start the API server and try again.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: mutedText),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'In VS Code, start with the “Blue Way (Chrome)” or '
                        '“Blue Way (Android emulator)” launch configuration. '
                        'Otherwise run run.bat from the project folder.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: mutedText),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: blueWayStore.load,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry connection'),
                      ),
                    ],
                  ),
                ),
              ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [HomePage(), BusListPage(), ProfilePage()],
      ),
      bottomNavigationBar: NavigationBar(
        // Shared navigation bar for Home, Buses, and Profile.
        // Styling is centralized in navigationBarTheme above.
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bus_outlined),
            selectedIcon: Icon(Icons.directions_bus),
            label: 'Buses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
