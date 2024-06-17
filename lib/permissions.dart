import 'package:permission_handler/permission_handler.dart';

Future<void> requestBluetoothPermissions() async {
  if (await Permission.bluetooth.isGranted &&
      await Permission.bluetoothConnect.isGranted) {
    // Permissions are already granted
    return;
  }

  // Request the required permissions
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan
  ].request();

  if (statuses[Permission.bluetooth]!.isDenied ||
      statuses[Permission.bluetoothConnect]!.isDenied) {
    // Handle the case when permissions are denied
    print("Bluetooth permissions are denied.");
  }
}