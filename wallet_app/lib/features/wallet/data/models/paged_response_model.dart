library;

class PagedResponseModel<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;
  bool get hasNextPage => page * pageSize < totalCount;
  bool get hasPreviousPage => page > 1;

  const PagedResponseModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  /// Deserializes a JSON map into a [PagedResponseModel<T>].
  /// The [itemParser] callback converts each raw item in the `items`
  /// array into the concrete type [T].
  factory PagedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemParser,
  ) => PagedResponseModel<T>(
      items: (json['items'] as List<dynamic>)
          .map((e) => itemParser(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
    );
}
