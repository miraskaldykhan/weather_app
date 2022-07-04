import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/cubit/weather_daily/weather_daily_cubit.dart';
import 'package:weather_app/cubit/weather_daily/weather_daily_states.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';

class SingleWeather extends StatefulWidget {
  final String? cityName;

  const SingleWeather({Key? key, this.cityName}) : super(key: key);

  @override
  State<SingleWeather> createState() => _SingleWeatherState();
}

class _SingleWeatherState extends State<SingleWeather> {
  String bgImg = 'assets/snow.jpg';

  @override
  Widget build(BuildContext context) {
    final WeatherDailyCubit weatherDailyCubit =
        context.read<WeatherDailyCubit>();
    return BlocBuilder<WeatherDailyCubit, WeatherDailyState>(
      builder: (context, state) {
        if(state is WeatherDailyInitialState){
          widget.cityName != null
              ? weatherDailyCubit.getWeatherDailyInfoWithCity(
              cityName: widget.cityName!)
              : weatherDailyCubit.getWeatherDailyInfoWithLonAndLat();
        }
        if (state is WeatherDailyLoadedState) {
          if (state.forecastDaily.list![0].weather![0].main == 'Rain') {
            bgImg = "assets/rainy.jpg";
          } else if (state.forecastDaily.list![0].weather![0].main ==
              'Clouds') {
            bgImg = "assets/cloudy.jpeg";
          } else if (state.forecastDaily.list![0].weather![0].main == 'Clear') {
            bgImg = "assets/sunny.jpg";
          }
          return Stack(children: [
            Image.asset(
              bgImg,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.black26),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mainInfo(state),
                    borderDivides(),
                    weatherInfo3hourly(context, state),
                  ],
                )),
          ]);
        } else if (state is WeatherDailyErrorState) {
          return Stack(children: [
            Image.asset(
              bgImg,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.black26),
            ),
            Center(
              child: Text("City not found or another error", style: GoogleFonts.lato(
                fontSize: 20,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold
              ),),
            )
          ]);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget mainInfo(WeatherDailyLoadedState state) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),
              Text(
                state.forecastDaily.city!.name ?? "Default",
                style: GoogleFonts.lato(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                state.forecastDaily.list![0].weather![0].description ??
                    "default",
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${state.forecastDaily.list![0].main!.temp!.toInt()}\u2103',
                style: GoogleFonts.lato(
                  fontSize: 86,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Row(children: [
                Expanded(
                  child: Image.network(
                    "${Constants.weatherImagesUrl + state.forecastDaily.list![0].weather![0].icon!}.png",
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.width / 6,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  state.forecastDaily.list![0].weather![0].main ?? "default",
                  style: GoogleFonts.lato(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  " , Feels like: ${state.forecastDaily.list![0].main!.feelsLike!.toInt()}\u2103",
                  style: GoogleFonts.lato(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget borderDivides() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.white30)),
        )
      ],
    );
  }

  Widget additionalInfo(WeatherDailyLoadedState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          addInfoCard("Wind", state.forecastDaily.list![0].wind!.speed!.toInt(),
              "km/h", 5),
          addInfoCard("Rain",
              state.forecastDaily.list![0].rain?.d3h!.toInt() ?? 0, "%", 10),
          addInfoCard("Humidity", state.forecastDaily.list![0].main!.humidity!,
              "%", 15),
        ],
      ),
    );
  }

  Widget weatherInfo3hourly(
      BuildContext context, WeatherDailyLoadedState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 10,
        color: Colors.transparent,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.forecastDaily.list!.length ~/ 4,
            itemBuilder: (context, index) {
              var time = DateTime.fromMillisecondsSinceEpoch(
                  state.forecastDaily.list![index].dt!.toInt() * 1000);
              return Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.height / 10,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        DateFormat.Hm().format(time),
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Image.network(
                          "${Constants.weatherImagesUrl + state.forecastDaily.list![index].weather![0].icon!}.png",
                          width: MediaQuery.of(context).size.width / 6,
                          height: MediaQuery.of(context).size.width / 6,
                        ),
                      ),
                      Text(
                        "${state.forecastDaily.list![index].main!.temp!.toInt()}\u2103",
                        style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ));
            }),
      ),
    );
  }

  Widget addInfoCard(String desc, int val, String type, double graBar) {
    return Column(
      children: [
        Text(
          desc,
          style: GoogleFonts.lato(
              fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        Text(
          "$val",
          style: GoogleFonts.lato(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        Text(
          type,
          style: GoogleFonts.lato(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        Stack(
          children: [
            Container(
              height: 5,
              width: 50,
              color: Colors.white38,
            ),
            Container(
              height: 5,
              width: graBar,
              color: Colors.greenAccent,
            ),
          ],
        )
      ],
    );
  }
}
