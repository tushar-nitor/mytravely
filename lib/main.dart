import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytravaly/core/theme/app_theme.dart';
import 'package:mytravaly/data/repositories/hotel_repo.dart';
import 'package:mytravaly/presentation/bloc/autocomplete/bloc/autocomplete_bloc.dart';
import 'package:mytravaly/presentation/bloc/popular_hotels/popular_hotels_bloc.dart';
import 'package:mytravaly/presentation/bloc/search_results/bloc/search_results_bloc.dart';
import 'package:mytravaly/presentation/pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HotelRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PopularHotelsBloc(hotelRepository: RepositoryProvider.of<HotelRepository>(context)),
          ),
          BlocProvider(
            create: (context) => SearchResultsBloc(hotelRepository: RepositoryProvider.of<HotelRepository>(context)),
          ),
          BlocProvider(
            create: (context) => AutocompleteBloc(hotelRepository: RepositoryProvider.of<HotelRepository>(context)),
          ),
        ],
        child: MaterialApp(
          title: 'MyTravaly Task',
          theme: AppTheme.light,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: const GoogleSignInPage(),
        ),
      ),
    );
  }
}
