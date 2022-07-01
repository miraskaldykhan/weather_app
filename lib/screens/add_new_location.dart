import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/cubit/locations/locations_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddingNewLocation extends StatefulWidget {
  AddingNewLocation({Key? key}) : super(key: key);

  @override
  State<AddingNewLocation> createState() => _AddingNewLocationState();
}

class _AddingNewLocationState extends State<AddingNewLocation> {
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LocationsListCubit locationsListCubit =
        context.read<LocationsListCubit>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            style: const TextStyle(fontSize: 20),
            controller: cityController,
            decoration: const InputDecoration(
              hintText: "Enter City Name",
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
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
                locationsListCubit.setCities(cityName: cityController.text);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
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
      ),
    );
  }
}
