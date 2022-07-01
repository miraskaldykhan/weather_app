abstract class LocationsListState{}

class LocationsListInitialState extends LocationsListState{
  List<String> cityList;
  LocationsListInitialState(this.cityList);
}

class LocationsListSetState extends LocationsListState{}

class LocationsListLoadedState extends LocationsListState{
  List<String> cityList;
  LocationsListLoadedState(this.cityList);
}

class LocationsListErrorState extends LocationsListState{
  String message;
  LocationsListErrorState(this.message);
}