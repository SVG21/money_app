import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/home/views/home_screen.dart';
import 'package:money_app/features/pay/views/pay_amount_screen.dart';
import 'package:money_app/features/top_up/views/top_up_screen.dart';
import 'package:money_app/features/currency_converter/views/currency_converter_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneyApp',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/pay': (context) => const PayAmountScreen(),
        '/topup': (context) => const TopUpScreen(),
        '/converter': (context) => const CurrencyConverterScreen(),
      },
    );
  }
}
