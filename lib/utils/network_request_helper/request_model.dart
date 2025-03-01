import 'dart:convert';

class AppHttpResponse {
  late dynamic result;
  final String message;
  final bool isSuccessful;

  AppHttpResponse({
    required this.message,
    required this.isSuccessful,
    required this.result,
  });
}

class SuccessResponse<T> extends AppHttpResponse {
  T? data;

  SuccessResponse(
      {this.data,
      super.message = "",
      super.isSuccessful = true,
      required super.result});

  SuccessResponse withConverter(HttpResponseConverter converter) {
    return SuccessResponse(
      data: converter(super.result),
      result: result,
      message: message,
    );
  }
}

class ErrorResponse extends AppHttpResponse {
  ErrorResponse({
    super.message = "",
    super.isSuccessful = false,
    super.result = const {},
  });
  factory ErrorResponse.defaultError({String? errorMessage}) =>
      ErrorResponse(message: errorMessage ?? "Failed to process request");

  @override
  String toString() => "ErrorResponse(message:$message)";
}

class ValidationError extends ErrorResponse {
  final List<ResponseError> errors;
  ValidationError({required this.errors, required super.message, super.result});

  factory ValidationError.fromJson(String json) {
    Map<String, dynamic> newJson = jsonDecode(json.toString());
    Iterable errorKeys = (newJson["errors"]).keys;

    List<Map<String, dynamic>> formattedErrors = errorKeys
        .map((e) => {"title": e, "message": newJson["errors"][e]})
        .toList();

    return ValidationError(
      errors: formattedErrors.map((e) => ResponseError.fromJson(e)).toList(),
      message: newJson["message"],
      result: {},
    );
  }
}

class ResponseError {
  final String errorTitle;
  final List<String> errorMessage;
  const ResponseError({required this.errorTitle, required this.errorMessage});

  factory ResponseError.fromJson(Map<String, dynamic> json) {
    return ResponseError(
        errorTitle: json["title"],
        errorMessage: (json["message"] as List<dynamic>)
            .map((e) => e.toString())
            .toList());
  }

  @override
  String toString() =>
      "HttpError(errorTitle: $errorTitle,errorMessage: $errorMessage)";
}

typedef HttpResponseConverter<T> = T Function(dynamic json);
