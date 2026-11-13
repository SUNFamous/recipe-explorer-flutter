import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/recipe_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'services/local_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalCacheService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
