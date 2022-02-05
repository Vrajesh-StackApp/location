import 'package:permission_handler/permission_handler.dart';

askPermission(Permission permission)async{
  await requestPermission(permission);
}

Future<void> requestPermission(Permission permission) async {
  final status = await permission.request();
  checkPermissionStatus(status);
}

checkPermissionStatus(PermissionStatus _permissionStatus) {
  switch (_permissionStatus) {
    case PermissionStatus.granted:
      return;
    case PermissionStatus.denied:
      return requestPermission(Permission.location);
    case PermissionStatus.permanentlyDenied:
      return openAppSettings();
    default:
      return;
  }
}

