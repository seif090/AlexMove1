import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../entities/trip.dart';

abstract class TrackingRepository {
  Future<Either<AppException, Trip>> getTripDetails(int tripId);

  Future<Either<AppException, List<Trip>>> getActiveTrips();

  Future<Either<AppException, Trip>> getTripByGroupId(int groupId);

  Future<Either<AppException, void>> updateDriverLocation({
    required int tripId,
    required double latitude,
    required double longitude,
  });

  Future<Either<AppException, void>> markStopVisited({
    required int tripId,
    required int stopId,
  });

  Future<Either<AppException, void>> pickupPassenger({
    required int tripId,
    required int userId,
  });

  Stream<Trip> watchTripLocation(int tripId);
}
