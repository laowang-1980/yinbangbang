import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/publish_screen.dart';
import 'screens/requests_screen.dart';
import 'screens/request_detail_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/search_screen.dart';
import 'providers/user_provider.dart';
import 'providers/request_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const YinbangbangApp());
}

class YinbangbangApp extends StatelessWidget {
  const YinbangbangApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 设置状态栏样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: CupertinoColors.systemBackground,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initTheme()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return CupertinoApp(
            title: '硬帮帮',
            debugShowCheckedModeBanner: false,
            theme: CupertinoThemeData(
              brightness: themeProvider.brightness,
              primaryColor: AppColors.primaryOrange,
              scaffoldBackgroundColor: themeProvider.isDarkMode 
                  ? CupertinoColors.black 
                  : CupertinoColors.systemGroupedBackground,
              barBackgroundColor: CupertinoColors.systemBackground,
              textTheme: const CupertinoTextThemeData(
                primaryColor: CupertinoColors.label,
              ),
            ),
            home: const SplashScreen(),
            localizationsDelegates: const [
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('zh', 'CN'),
            ],
            routes: {
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/publish': (context) => const PublishScreen(),
              '/requests': (context) => const RequestsScreen(),
              '/orders': (context) => const OrdersScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/search': (context) => const SearchScreen(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/request_detail':
                  final args = settings.arguments as Map<String, dynamic>;
                  return CupertinoPageRoute(
                    builder: (context) => RequestDetailScreen(
                      request: args['request'],
                    ),
                  );
                case '/chat':
                  final args = settings.arguments as Map<String, dynamic>;
                  return CupertinoPageRoute(
                    builder: (context) => ChatScreen(
                      otherUserId: args['otherUserId'],
                      otherUserName: args['otherUserName'],
                    ),
                  );
                case '/payment':
                  final args = settings.arguments as Map<String, dynamic>;
                  return CupertinoPageRoute(
                    builder: (context) => PaymentScreen(
                      request: args['request'],
                      helper: args['helper'],
                      totalAmount: args['totalAmount'],
                    ),
                  );
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}