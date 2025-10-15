class PaginationInfo {
  final int total;
  final int pages;
  final int currentPage;
  final int limit;

  PaginationInfo({required this.total, required this.pages, required this.currentPage, required this.limit});

  factory PaginationInfo.fromHeaders(Map<String, List<String>> headers) {
    return PaginationInfo(
      total: int.parse(headers['x-pagination-total']?.first ?? '0'),
      pages: int.parse(headers['x-pagination-pages']?.first ?? '0'),
      currentPage: int.parse(headers['x-pagination-page']?.first ?? '0'),
      limit: int.parse(headers['x-pagination-limit']?.first ?? '0'),
    );
  }
}
