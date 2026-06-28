import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/trip.dart';
import '../providers/tracking_provider.dart';
import '../widgets/trip_info_sheet.dart';

class TrackingMapScreen extends ConsumerStatefulWidget {
  final int tripId;

  const TrackingMapScreen({super.key, required this.tripId});

  @override
  ConsumerState<TrackingMapScreen> createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends ConsumerState<TrackingMapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripDetailProvider(widget.tripId));

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: tripAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => _buildErrorState(error.toString()),
        data: (tripValue) => tripValue.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, _) => _buildErrorState(error.toString()),
          data: (trip) => _buildMapContent(trip),
        ),
      ),
    );
  }

  Widget _buildMapContent(Trip trip) {
    _updateMarkersAndRoute(trip);

    final initialPosition = trip.currentLatitude != null && trip.currentLongitude != null
        ? LatLng(trip.currentLatitude!, trip.currentLongitude!)
        : const LatLng(
            AppConstants.defaultLatitude,
            AppConstants.defaultLongitude,
          );

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: AppConstants.defaultZoom,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            ref.read(trackingMapInitializedProvider.notifier).state = true;
          },
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
          onCameraMove: (_) {},
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          child: _buildTopBar(trip),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.2,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    TripInfoSheet(trip: trip),
                    if (trip.passengers.isNotEmpty)
                      _buildPassengerList(trip),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.3,
          right: 16,
          child: _buildMapControls(),
        ),
      ],
    );
  }

  Widget _buildTopBar(Trip trip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.lightOnSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.routeName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurface,
                  ),
                ),
                Text(
                  trip.groupName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: trip.status == TripStatus.inProgress
                  ? AppColors.successLight
                  : trip.status == TripStatus.completed
                      ? AppColors.infoLight
                      : AppColors.warningLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              trip.status == TripStatus.inProgress
                  ? 'Live'
                  : trip.status == TripStatus.completed
                      ? 'Done'
                      : 'Soon',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
                color: trip.status == TripStatus.inProgress
                    ? AppColors.successDark
                    : trip.status == TripStatus.completed
                        ? AppColors.info
                        : AppColors.warningDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        _buildControlButton(
          icon: Icons.add,
          onTap: () {
            _mapController?.animateCamera(CameraUpdate.zoomIn());
          },
        ),
        const SizedBox(height: 8),
        _buildControlButton(
          icon: Icons.remove,
          onTap: () {
            _mapController?.animateCamera(CameraUpdate.zoomOut());
          },
        ),
        const SizedBox(height: 8),
        _buildControlButton(
          icon: Icons.my_location,
          onTap: _centerOnDriver,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.lightOnSurface),
      ),
    );
  }

  Widget _buildPassengerList(Trip trip) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Passengers',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...trip.passengers.map((passenger) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: passenger.isPickedUp
                      ? AppColors.successLight
                      : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      passenger.isPickedUp
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: passenger.isPickedUp
                          ? AppColors.success
                          : AppColors.lightOnSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            passenger.userName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                              color: passenger.isPickedUp
                                  ? AppColors.successDark
                                  : AppColors.lightOnSurface,
                            ),
                          ),
                          Text(
                            passenger.pickupLocation,
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: 'Cairo',
                              color: AppColors.lightOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(tripDetailProvider(widget.tripId));
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMarkersAndRoute(Trip trip) {
    _markers.clear();
    _polylines.clear();

    if (trip.currentLatitude != null && trip.currentLongitude != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(trip.currentLatitude!, trip.currentLongitude!),
          infoWindow: InfoWindow(
            title: trip.driverName,
            snippet: trip.vehiclePlate,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    for (var i = 0; i < trip.routeStops.length; i++) {
      final stop = trip.routeStops[i];
      _markers.add(
        Marker(
          markerId: MarkerId('stop_${stop.id}'),
          position: LatLng(stop.latitude, stop.longitude),
          infoWindow: InfoWindow(
            title: 'Stop ${i + 1}',
            snippet: stop.name,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            stop.isVisited
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }

    if (trip.routeStops.length >= 2) {
      final points = trip.routeStops
          .map((s) => LatLng(s.latitude, s.longitude))
          .toList();

      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: AppColors.primary,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      );
    }

    if (trip.currentLatitude != null && trip.routeStops.isNotEmpty) {
      final lastStop = trip.routeStops.last;
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('driver_to_route'),
          points: [
            LatLng(trip.currentLatitude!, trip.currentLongitude!),
            LatLng(lastStop.latitude, lastStop.longitude),
          ],
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          patterns: [PatternItem.dash(20)],
        ),
      );
    }
  }

  void _centerOnDriver() {
    final trip = ref.read(tripDetailProvider(widget.tripId));
    trip.whenData((tripValue) {
      tripValue.whenData((trip) {
        if (trip.currentLatitude != null && trip.currentLongitude != null) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(trip.currentLatitude!, trip.currentLongitude!),
              AppConstants.markerZoom,
            ),
          );
        }
      });
    });
  }
}
