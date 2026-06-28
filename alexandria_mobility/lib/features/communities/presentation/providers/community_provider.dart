import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/community.dart';
import '../../data/repositories/community_repository_impl.dart';

final communitiesSearchProvider = StateProvider<String>((ref) => '');

final communitiesPageProvider = StateProvider<int>((ref) => 1);

final communitiesProvider =
    FutureProvider.autoDispose<AsyncValue<PaginatedResponse<Community>>>(
        (ref) async {
  final repository = ref.watch(communityRepositoryProvider);
  final search = ref.watch(communitiesSearchProvider);
  final page = ref.watch(communitiesPageProvider);

  final result = await repository.getCommunities(
    pageNumber: page,
    search: search.isNotEmpty ? search : null,
  );

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final communityDetailProvider =
    FutureProvider.autoDispose.family<AsyncValue<Community>, int>((ref, id) async {
  final repository = ref.watch(communityRepositoryProvider);
  final result = await repository.getCommunity(id);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final myCommunitiesProvider =
    FutureProvider.autoDispose<AsyncValue<PaginatedResponse<Community>>>(
        (ref) async {
  final repository = ref.watch(communityRepositoryProvider);
  final page = ref.watch(communitiesPageProvider);

  final result = await repository.getMyCommunities(pageNumber: page);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final joinCommunityProvider =
    FutureProvider.autoDispose.family<AsyncValue<void>, int>((ref, communityId) async {
  final repository = ref.watch(communityRepositoryProvider);
  final result = await repository.joinCommunity(communityId);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (_) => const AsyncValue.data(null),
  );
});
