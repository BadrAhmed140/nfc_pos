import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_pos/blocs/nfc_pos/nfc_pos_cubit.dart';
import 'package:nfc_pos/screens/splash_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NfcPosCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'NFC POS',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar'), // arabic
        ],
        theme: FlexThemeData.light(
            useMaterial3: true,
            scheme: FlexScheme.redM3,
            textTheme: GoogleFonts.cairoTextTheme().copyWith(
              bodyLarge: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              bodyMedium: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            )),
        home: const SplashScreen(),
      ),
    );
  }
}
