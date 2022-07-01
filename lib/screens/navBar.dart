import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cubit/locations/locations_cubit.dart';
import '../cubit/weather_daily/weather_daily_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocationsListCubit locationsListCubit =
        context.read<LocationsListCubit>();
    final WeatherDailyCubit weatherDailyCubit =
        context.read<WeatherDailyCubit>();
    locationsListCubit.getCities();
    return Drawer(
      backgroundColor: Colors.white60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawerHeader(
            child: Text("Please choose city", style: GoogleFonts.lato(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
          ),
          for (int i = 0; i < locationsListCubit.cities.length + 1; i++)
            i != locationsListCubit.cities.length
                ? GestureDetector(
                    onTap: () {
                      weatherDailyCubit.getWeatherDailyInfoWithCity(
                          cityName: locationsListCubit.cities[i]);
                      Navigator.of(context).pop();
                    },
                    child: Dismissible(
                      key: Key(locationsListCubit.cities[i]),
                      background: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.red,
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        locationsListCubit.deleteCities(
                            cityName: locationsListCubit.cities[i]);
                        locationsListCubit.getCities();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        width: MediaQuery.of(context).size.width / 2,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          locationsListCubit.cities[i],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      weatherDailyCubit.getWeatherDailyInfoWithLonAndLat();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width / 2,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "My location",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
