import 'package:content_managment_app_test/canvas_selection.dart';
import 'package:content_managment_app_test/client_screen.dart';
import 'package:content_managment_app_test/home.dart';

import 'package:content_managment_app_test/logic/home_cubit.dart';
import 'package:content_managment_app_test/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ContentCubit()),
      ],
      child: const MaterialApp(
        home: Scaffold(body: ClientScreen()),
      ),
    );
  }
}
