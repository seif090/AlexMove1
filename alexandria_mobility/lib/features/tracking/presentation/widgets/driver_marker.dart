import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class DriverMarkerWidget extends StatelessWidget {
  final double heading;

  const DriverMarkerWidget({super.key, this.heading = 0});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: heading * (3.14159 / 180),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

Marker createDriverMarker({
  required LatLng position,
  required int tripId,
  double heading = 0,
}) {
  return Marker(
    markerId: MarkerId('driver_$tripId'),
    position: position,
    infoWindow: const InfoWindow(title: 'Driver'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    rotation: heading,
    anchor: const Offset(0.5, 0.5),
  );
}
