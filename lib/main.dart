import 'package:flutter/material.dart';
import 'package:knovator_vinit/provider/post_provider.dart';
import 'package:knovator_vinit/screens/post_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Knovator Vinit',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home:  const PostListScreen(),
      ),
    );
  }
}

