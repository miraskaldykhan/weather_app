import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/widgets/singleWeatherPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/locations/locations_cubit.dart';
import '../cubit/weather_daily/weather_daily_cubit.dart';
import 'navBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LocationsListCubit locationsListCubit =
        context.read<LocationsListCubit>();
    final WeatherDailyCubit weatherDailyCubit =
        context.read<WeatherDailyCubit>();
    locationsListCubit.getCities();
    return Scaffold(
      drawer: const NavBar(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              size: MediaQuery.of(context).size.width / 12,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white70,
                      title: Text(
                        "Adding City",
                        style: GoogleFonts.lato(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content:
                          searchCity(locationsListCubit, weatherDailyCubit),
                    );
                  });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleWeather(
            cityName: locationsListCubit.cities.isNotEmpty
                ? locationsListCubit.cities.last
                : null,
          ),
        ),
      ),
    );
  }

  Widget searchCity(LocationsListCubit locationsListCubit,
      WeatherDailyCubit weatherDailyCubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          style: const TextStyle(fontSize: 20, color: Colors.white),
          controller: cityController,
          decoration: const InputDecoration(
            hintText: "City Name",
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            prefixIcon: Icon(
              Icons.location_city,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: ElevatedButton(
            onPressed: () {
              if (cityController.text.isNotEmpty) {
                locationsListCubit.setCities(cityName: cityController.text);
                weatherDailyCubit.getWeatherDailyInfoWithCity(cityName: cityController.text);
                Navigator.of(context).pop();
                cityController.clear();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
            ),
            child: Text(
              "Add",
              style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
