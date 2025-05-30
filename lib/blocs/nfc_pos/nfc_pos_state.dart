part of 'nfc_pos_cubit.dart';

@immutable
abstract class NfcPosState {}

class NfcPosInitial extends NfcPosState {}

class SuccessLoginState extends NfcPosState {}

class LoadingLoginState extends NfcPosState {}

class ErrorLoginState extends NfcPosState {
  final String error;
  ErrorLoginState(this.error);
}

class SuccessGetCardInfoState extends NfcPosState {}

class LoadingGetCardInfoState extends NfcPosState {}

class ErrorGetCardInfoState extends NfcPosState {
  final String error;
  ErrorGetCardInfoState(this.error);
}

class SuccessReadCardDataState extends NfcPosState {}

class LoadingReadCardDataState extends NfcPosState {}

class ErrorReadCardDataState extends NfcPosState {
  final String error;
  ErrorReadCardDataState(this.error);
}

class SuccessAddOrderState extends NfcPosState {}

class LoadingAddOrderState extends NfcPosState {}

class ErrorAddOrderState extends NfcPosState {
  final String error;
  ErrorAddOrderState(this.error);
}

// states for confirm order
class SuccessConfirmOrderState extends NfcPosState {}

class LoadingConfirmOrderState extends NfcPosState {}

class ErrorConfirmOrderState extends NfcPosState {
  final String error;
  ErrorConfirmOrderState(this.error);
}
