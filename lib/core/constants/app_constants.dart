class AppConstants {
  static const String baseUrl = 'https://daffy-stg.inplsnd.com/api/v1';
  static const String loginUrl = '/login';
  static const String getDistributorUrl = '/distributor/getTsoWiseDistributor';
  static const String getRouteUrl = '/route/getTsoDistributorWiseRoute';
  static const String checkInUrl = '/attendence/in';
  static const String checkOutUrl = '/attendence/out';

  static const String profileBox = 'profileBox';
  static const String attendanceBox = 'attendanceBox';
  static const String authBox = 'authBox';
  
  static const String keyUser = 'user';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyToken = 'token';
  static const String keyActiveAttendanceId = 'activeAttendanceId';
  static const String keyIsCheckedIn = 'isCheckedIn';
  static const String keyCheckInTime = 'checkInTime';
}
