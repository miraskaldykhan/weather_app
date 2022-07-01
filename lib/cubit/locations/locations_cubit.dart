import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/weather_api_repo.dart';
import 'locations_state.dart';

class LocationsListCubit extends Cubit<LocationsListState> {
  final WeatherApiRepository _weatherApiRepository;
  List<String> cities = [];

  LocationsListCubit({required WeatherApiRepository weatherApiRepository})
      : _weatherApiRepository = weatherApiRepository,
        super(LocationsListInitialState([]));

  Future<void> getCities() async {
    try{
      cities = await _weatherApiRepository.getCitiesLocally();
      emit(LocationsListInitialState(cities));
    }catch (e){
      print("error in getCities method");
    }
  }

  Future<void> setCities({required String cityName}) async{
    emit(LocationsListSetState());
    try{
      final String response = await _weatherApiRepository.saveCitiesLocally(cityName: cityName);
      if(response == 'Success'){
        print("Success in setCities");
        final List<String> cities = await _weatherApiRepository.getCitiesLocally();
        emit(LocationsListLoadedState(cities));
      }else{
        print("Error in setCities response");
      }
    }catch (e){
      print("error in setCities method");
    }
  }
  Future<void> deleteCities({required String cityName}) async{
    emit(LocationsListSetState());
    try{
      final String response = await _weatherApiRepository.deleteCitiesLocally(cityName: cityName);
      if(response == 'Success deleted'){
        print("Deleted in deleteCities");
        final List<String> cities = await _weatherApiRepository.getCitiesLocally();
        emit(LocationsListLoadedState(cities));
      }else{
        print("Error in deleteCities response");
      }
    }catch (e){
      print("error in deleteCities method");
    }
  }
}
