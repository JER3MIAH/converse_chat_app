import 'dart:developer';
import 'dart:io';
import 'package:converse/src/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// custom exception class for handling exceptions in the api_client
class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  static ApiException getException(err) {
    debugPrint('DioError: ${(err as DioException).message}');
    debugPrint('DioError: ${err.response?.data}');
    switch (err.type) {
      // if the request was cancelled
      case DioExceptionType.cancel:
        return OtherExceptions(kRequestCancelledError);

      // timeout errors

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.badCertificate:
        return InternetConnectException(kTimeOutError);

      // others - handle other types of custom exceptions here
      case DioExceptionType.unknown:
        // format exception
        if (err.error is FormatException) {
          return FormatException();
        }
        // socket exception
        if (err.error is SocketException) {
          return InternetConnectException("No internet connection. Try again");
          // return InternetConnectException(kInternetConnectionError);
        }
        break;
      case DioExceptionType.badResponse:
        /* cases where we have a custom error message from the APIs
        We'll have a response from the APIs [for some status codes],

        IF THERE IS A PAYLOAD,

        {
          "status": false,
          "message": "Incorrect credentials",
        }

        we extract the value present in the key=>[message]
        */
        try {
          if (err.response?.data != null) {
            if ((err.response!.data as Map)['message'] is Map) {
              return OtherExceptions(
                ((err.response!.data as Map)['message'] as Map)['message'],
              );
            }
            return OtherExceptions((err.response!.data as Map)['message']);
          } else {
            // IF THERE IS NO PAYLOAD, we check for respective status codes and assign dimfit error messages
            switch (err.response?.statusCode) {
              case 500:
                return InternalServerException();
              case 404:
              case 502:
                return OtherExceptions(kNotFoundError);
              case 400:
                return OtherExceptions(kBadRequestError);
              case 403:
              case 401:
                return UnAuthorizedException();
              default:
                // default exception error message
                return OtherExceptions(kDefaultError);
            }
          }
        } catch (err) {
          log(err.toString());
          return OtherExceptions(kDefaultError);
        }
    }
    // default exception error message
    return OtherExceptions(kDefaultError);
  }
}

class OtherExceptions implements ApiException {
  OtherExceptions(this.newMessage);

  final String newMessage;

  @override
  String toString() => message;

  @override
  String get message => newMessage;
}

class FormatException implements ApiException {
  @override
  String toString() => message;

  @override
  String get message => kFormatError;
}

class InternetConnectException implements ApiException {
  InternetConnectException(this.newMessage);

  final String newMessage;

  @override
  String toString() => message;

  @override
  String get message => newMessage;
}

class InternalServerException implements ApiException {
  @override
  String toString() {
    return message;
  }

  @override
  String get message => kServerError;
}

class UnAuthorizedException implements ApiException {
  @override
  String toString() {
    return message;
  }

  @override
  String get message => kUnAuthorizedError;
}

class CacheException implements Exception {
  CacheException(this.message) : super();

  String message;

  @override
  String toString() {
    return message;
  }
}
