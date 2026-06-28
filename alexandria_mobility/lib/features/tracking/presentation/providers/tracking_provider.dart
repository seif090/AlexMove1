import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/trip.dart';
import '../../data/repositories/tracking_repository_impl.dart';

final activeTripsProvider = FutureProvider.autoDispose<AsyncValue<List<Trip>>>((ref) async {
  final repository = ref.watch(trackingRepositoryProvider);
  final result = await repository.getActiveTrips();

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final tripDetailProvider =
    FutureProvider.autoDispose.family<AsyncValue<Trip>, int>((ref, tripId) async {
  final repository = ref.watch(trackingRepositoryProvider);
  final result = await repository.getTripDetails(tripId);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final tripByGroupIdProvider =
    FutureProvider.autoDispose.family<AsyncValue<Trip>, int>((ref, groupId) async {
  final repository = ref.watch(trackingRepositoryProvider);
  final result = await repository.getTripByGroupId(groupId);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final driverLocationProvider =
    StreamProvider.autoDispose.family<Trip, int>((ref, tripId) {
  final repository = ref.watch(trackingRepositoryProvider);
  return repository.watchTripLocation(tripId);
});

final selectedTripProvider = StateProvider<Trip?>((ref) => null);

final trackingMapInitializedProvider = StateProvider<bool>((ref) => false);
