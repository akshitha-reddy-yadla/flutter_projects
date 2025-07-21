import 'package:flutter/material.dart';
import 'package:responsive_flutter_app/courses_page.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() => runApp(const AppWidget());

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 350, name: MOBILE),
              const Breakpoint(start: 351, end: 600, name: TABLET),
              const Breakpoint(start: 601, end: 800, name: DESKTOP),
              const Breakpoint(start: 801, end: 1700, name: 'XL'),
            ],
          ),
      // builder: (context, widget) => Responsive,
      // builder: (context, widget) => ,
      title: 'Flutter Responsive Framework',
      home: const CoursesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
