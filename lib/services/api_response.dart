/// ApiResponse
/// Standart API Response status and data holder
class ApiResponse<T> {
  late RequestStatus requestStatus;
  late T data;
  late String statusMessage;

  ApiResponse.loading(this.statusMessage)
      : requestStatus = RequestStatus.loading;
  ApiResponse.completed(this.data) : requestStatus = RequestStatus.completed;
  ApiResponse.error(this.statusMessage) : requestStatus = RequestStatus.error;

  @override
  String toString() {
    return "Status : $requestStatus \n Message : $statusMessage \n Data : $data";
  }
}

enum RequestStatus { loading, completed, error }
