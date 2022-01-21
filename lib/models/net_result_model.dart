class NetResult<T> {
  final int errorCode;
  final String? errorMsg;
  final T? data;

  NetResult({required this.errorCode, this.errorMsg, this.data});

  factory NetResult.fromJson(dynamic item) {
    return NetResult(
        errorCode: item['errorCode'],
        errorMsg: item['errorMsg'],
        data: item['data']);
  }
}
