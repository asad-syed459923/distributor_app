import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Turn on location services';
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw 'Location permission denied';
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission permanently denied';
    }

    return Geolocator.getCurrentPosition();
  }
}
