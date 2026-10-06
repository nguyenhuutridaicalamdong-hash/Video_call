import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_wrapper.dart';
import 'screens/call/incoming_call_screen.dart';
import 'screens/call/video_call_screen.dart';
import 'screens/call/call_ended_screen.dart';

import 'models/contact_model.dart';
import 'screens/call/zego_call_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not initialized yet: $e');
  }
  runApp(const VCallApp());
}

class VCallApp extends StatelessWidget {
  const VCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VCall',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.main: (context) => const MainWrapper(),
        AppRoutes.incomingCall: (context) => const IncomingCallScreen(),
        AppRoutes.videoCall: (context) => const VideoCallScreen(),
        AppRoutes.zegoCall: (context) {
          final contact = ModalRoute.of(context)?.settings.arguments as ContactModel? ??
              const ContactModel(
                id: '1',
                name: 'Minh Nguyễn',
                email: 'minh.nguyen@example.com',
                isOnline: true,
              );
          return ZegoCallPage(contact: contact);
        },
        AppRoutes.callEnded: (context) => const CallEndedScreen(),
      },
    );
  }
}
