import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/booking.dart';
import '../../data/repositories/booking_repository_impl.dart';

final bookingStatusFilterProvider = StateProvider<String?>((ref) => null);

final bookingPageProvider = StateProvider<int>((ref) => 1);

final bookingListProvider =
    FutureProvider.autoDispose<AsyncValue<PaginatedResponse<Booking>>>(
        (ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  final status = ref.watch(bookingStatusFilterProvider);
  final page = ref.watch(bookingPageProvider);

  final result = await repository.getMyBookings(
    pageNumber: page,
    status: status,
  );

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final bookingDetailProvider =
    FutureProvider.autoDispose.family<AsyncValue<Booking>, int>((ref, id) async {
  final repository = ref.watch(bookingRepositoryProvider);
  final result = await repository.getBookingDetails(id);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final createBookingProvider =
    StateNotifierProvider<CreateBookingNotifier, AsyncValue<Booking?>>(
        (ref) {
  return CreateBookingNotifier(ref);
});

class CreateBookingNotifier extends StateNotifier<AsyncValue<Booking?>> {
  final Ref _ref;

  CreateBookingNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> createBooking({
    required int groupId,
    required String bookingDate,
    String? pickupLocation,
    String? dropoffLocation,
    int seats = 1,
  }) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(bookingRepositoryProvider);

    final result = await repository.createBooking(
      groupId: groupId,
      bookingDate: bookingDate,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      seats: seats,
    );

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (booking) {
        state = AsyncValue.data(booking);
        _ref.invalidate(bookingListProvider);
        return true;
      },
    );
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final cancelBookingProvider =
    StateNotifierProvider<CancelBookingNotifier, AsyncValue<void>>((ref) {
  return CancelBookingNotifier(ref);
});

class CancelBookingNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  CancelBookingNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> cancelBooking({
    required int bookingId,
    String? reason,
  }) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(bookingRepositoryProvider);

    final result = await repository.cancelBooking(
      bookingId: bookingId,
      reason: reason,
    );

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(bookingListProvider);
        return true;
      },
    );
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
