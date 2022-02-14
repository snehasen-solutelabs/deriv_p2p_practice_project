import 'package:deriv_p2p_practice_project/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Todo(farzin): Set fields to final and fix equatable.
/// Data model for server errors.
// ignore: must_be_immutable
class APIError extends Equatable implements Exception {
  /// Constructs a new APIError.
  APIError({
    this.code,
    this.message,
    this.errorType,
  });

  /// Constructs a new APIError from the given Map object.
  factory APIError.fromMap(Map<String, dynamic> data) => APIError(
        code: data['code'],
        message: data['message'],
        errorType: APIErrorType.serverError,
      );

  // Todo(farzin): Shouldn't be nullable.
  /// Contains the error code got from server.
  String? code;

  // Todo(farzin): Shouldn't be nullable.
  /// Contains the error message got from server.
  String? message;

  // Todo(farzin): Can be removed once we got rid of hardcoded enums.
  /// Determines the error type.
  APIErrorType? errorType;

  /// Checks if the error code is `P2PDisabled`.
  bool get isP2PDisabled => code == 'P2PDisabled';

  /// Checks if the error code is `PermissionDenied`.
  bool get isUserUnwelcome => code == 'PermissionDenied';

  /// Checks if the error code is `InvalidToken`.
  bool get isTokenExpired => code == 'InvalidToken';

  /// Checks if the error code is `AccountDisabled`.
  bool get isAccountDisabled => code == 'AccountDisabled';

  /// Checks if the error code is `DisabledClient`.
  bool get isDisabledClient => code == 'DisabledClient';

  /// Checks if the error code is `AlreadySubscribed`.
  bool get isAlreadySubscribed => code == 'AlreadySubscribed';

  /// Checks if the error code is `RestrictedCountry`.
  bool get isRestrictedCountry => code == 'RestrictedCountry';

  /// Checks if the error code is `AdvertiserNotFound`.
  bool get isAdvertiserNotFound => code == 'AdvertiserNotFound';

  /// Checks if the error code is `PermissionDenied`.
  bool get isPermissionDenied => code == 'PermissionDenied';

  /// Checks if the error code is `AdvertSameLimits`.
  bool get isAdvertSameLimits => code == 'AdvertSameLimits';

  /// Checks if the error code is `DuplicateAdvert`.
  bool get isDuplicateAdvert => code == 'DuplicateAdvert';

  /// Checks if the error code is `AdvertMaxExceededSameType`.
  bool get isAdvertMaxExceededSameType => code == 'AdvertMaxExceededSameType';

  /// Checks if the error code is `isUserDisabled`, `isUserUnwelcome` or
  /// `isTokenExpired`.
  bool get isUserAccessDenied =>
      isUserDisabled || isUserUnwelcome || isTokenExpired;

  /// Checks if the error code is `isUserDisabled` or `DisabledClient`.
  bool get isUserDisabled => isAccountDisabled || isDisabledClient;

  // Todo(farzin): Can be removed once we got rid of hardcoded enums.
  /// Checks if the APIError was created locally.
  bool get isLocal =>
      message == null &&
      errorType != null &&
      errorType != APIErrorType.serverError;

  // Todo(farzin): We should user server response instead of hardcoded enums.
  /// Creates a local APIError based on errorType.
  APIError fromLocal(BuildContext context) {
    switch (errorType) {
      case APIErrorType.disableAccount:
        code = 'Your account is suspended';
        // message = Localization.of(context).please_contact_custo_818798154;
        break;
      case APIErrorType.unwelcomeAccount:
        code = 'Your account is suspended';
        // message = Localization.of(context).we_re_unable_to_sign_319319381;
        break;
      case APIErrorType.expiredAccount:
        code = 'Your session has expired';
        // message = Localization.of(context).please_login_again_6661520;
        break;
      case APIErrorType.unsupportedCurrency:
        code = 'NotAvailable';
        //message = Localization.of(context).sorry_we_only_suppor_558084387;
        break;
      case APIErrorType.notAvailableCountry:
        code = 'NotAvailable';
        // message = Localization.of(context).this_service_is_curr_852880888;
        break;
      case APIErrorType.accountNotLoaded:
        //  message = Localization.of(context).account_not_loaded_501353635;
        break;
      case APIErrorType.unknownError:
        //   message = Localization.of(context).something_went_wrong_690169355;
        break;
      default:
        break;
    }

    return this;
  }

  /// Modifies error messages that are fetched from Server.
  APIError modifyServerError(BuildContext context) {
    switch (code) {
      case 'AdvertSameLimits':
        // message = Localization.of(context).please_set_a_differe_611875415;
        break;
      case 'DuplicateAdvert':
        //  message = Localization.of(context).you_already_have_an_835625527;
        break;
      default:
        break;
    }

    return this;
  }

  @override
  List<String?> get props => <String?>[code, message];
}
