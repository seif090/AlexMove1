import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/trip.dart';

abstract class TrackingRemoteDataSource {
  Future<Trip> getTripDetails(int tripId);

  Future<List<Trip>> getActiveTrips();

  Future<Trip> getTripByGroupId(int groupId);

  Future<void> updateDriverLocation({
    required int tripId,
    required double latitude,
    required double longitude,
  });

  Future<void> markStopVisited({
    required int tripId,
    required int stopId,
  });

  Future<void> pickupPassenger({
    required int tripId,
    required int userId,
  });
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final Dio _dio;

  TrackingRemoteDataSourceImpl(this._dio);

  @override
  Future<Trip> getTripDetails(int tripId) async {
    final response = await _dio.get('/trips/$tripId');
    return Trip.fromJson(response.data['data']);
  }

  @override
  Future<List<Trip>> getActiveTrips() async {
    final response = await _dio.get('/trips/active');
    return (response.data['data'] as List)
        .map((item) => Trip.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Trip> getTripByGroupId(int groupId) async {
    final response = await _dio.get('/trips/group/$groupId');
    return Trip.fromJson(response.data['data']);
  }

  @override
  Future<void> updateDriverLocation({
    required int tripId,
    required double latitude,
    required double longitude,
  }) async {
    await _dio.put(
      '/trips/$tripId/location',
      data: {'latitude': latitude, 'longitude': longitude},
    );
  }

  @override
  Future<void> markStopVisited({
    required int tripId,
    required int stopId,
  }) async {
    await _dio.post('/trips/$tripId/stops/$stopId/visit');
  }

  @override
  Future<void> pickupPassenger({
    required int tripId,
    required int userId,
  }) async {
    await _dio.post('/trips/$tripId/passengers/$userId/pickup');
  }
}

final trackingRemoteDataSourceProvider = Provider<TrackingRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TrackingRemoteDataSourceImpl(dio);
});
