import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<Permission> requestStoragePermission() async {
    final storagePermission = Permission.storage;
    final permissionStatus = await storagePermission.status;
    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else if (permissionStatus == PermissionStatus.denied) {
      storagePermission.request();
    }
    return storagePermission;
  }
}
