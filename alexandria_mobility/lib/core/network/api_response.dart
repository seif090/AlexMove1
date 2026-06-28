class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final List<String> errors;

  const ApiResponse({
    required this.isSuccess,
    this.data,
    this.message,
    this.errors = const [],
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      message: json['message'] as String?,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class PaginatedResponse<T> {
  final List<T> items;
  final int totalCount;
  final int pageNumber;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginatedResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => fromJsonT != null ? fromJsonT(e) : e as T)
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      pageNumber: json['pageNumber'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
    );
  }
}
