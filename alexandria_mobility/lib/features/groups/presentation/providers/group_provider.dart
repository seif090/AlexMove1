import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/group.dart';
import '../../data/repositories/group_repository_impl.dart';

final groupsSearchProvider = StateProvider<String>((ref) => '');

final groupsStatusFilterProvider = StateProvider<String?>((ref) => null);

final groupsPageProvider = StateProvider<int>((ref) => 1);

final groupsProvider =
    FutureProvider.autoDispose<AsyncValue<PaginatedResponse<Group>>>(
        (ref) async {
  final repository = ref.watch(groupRepositoryProvider);
  final search = ref.watch(groupsSearchProvider);
  final status = ref.watch(groupsStatusFilterProvider);
  final page = ref.watch(groupsPageProvider);

  final result = await repository.getGroups(
    pageNumber: page,
    search: search.isNotEmpty ? search : null,
    status: status,
  );

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final groupDetailProvider =
    FutureProvider.autoDispose.family<AsyncValue<Group>, int>((ref, id) async {
  final repository = ref.watch(groupRepositoryProvider);
  final result = await repository.getGroup(id);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final myGroupsProvider =
    FutureProvider.autoDispose<AsyncValue<PaginatedResponse<Group>>>(
        (ref) async {
  final repository = ref.watch(groupRepositoryProvider);
  final page = ref.watch(groupsPageProvider);

  final result = await repository.getMyGroups(pageNumber: page);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final searchGroupsProvider =
    FutureProvider.autoDispose.family<AsyncValue<PaginatedResponse<Group>>, String>(
        (ref, query) async {
  final repository = ref.watch(groupRepositoryProvider);

  if (query.isEmpty) {
    return const AsyncValue.data(PaginatedResponse(
      items: [],
      totalCount: 0,
      pageNumber: 1,
      totalPages: 0,
      hasPreviousPage: false,
      hasNextPage: false,
    ));
  }

  final result = await repository.searchGroups(query: query);

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});
