import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:nfc_pos/models/company_model.dart';
import 'package:nfc_pos/models/user_model.dart';
import 'package:nfc_pos/service/http_helper.dart';
import 'package:uuid/uuid.dart';

part 'nfc_pos_state.dart';

class NfcPosCubit extends Cubit<NfcPosState> {
  // login form controllers
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  //benzin controllers
  final benzin80Controller = TextEditingController(text: '0');

  // Gas Station Token
  String? token;

  // user data
  UserModel? currentUser;

  // current company details
  CompanyModel? currentCompany;

  // current card id
  String? cardId;

  // internal code
  String? internalCode;

  // constructor
  NfcPosCubit() : super(NfcPosInitial());

  // get cubit instance
  static NfcPosCubit get(context) => BlocProvider.of(context);

  // login method
  Future<void> login({required String name, required String passWord}) async {
    emit(LoadingLoginState());
    await HttpHelper.login(name: name, passWord: passWord).then((value) {
      emit(SuccessLoginState());
      if (value.statusCode == 200) {
        token = jsonDecode(value.body)["token"];
        currentUser = UserModel.fromJson(JWT.decode(token!).payload);
      }
    }).catchError((error, st) {
      emit(ErrorLoginState(error.message.toString()));
    });
  }

  // get card info method
  Future<void> getCardInfo({required String cardId}) async {
    emit(LoadingGetCardInfoState());
    await HttpHelper.getCardInfo(token: token!, cardId: cardId).then((value) {
      emit(SuccessGetCardInfoState());
      if (value.statusCode == 200) {
        currentCompany = CompanyModel.fromJson(jsonDecode(value.body));
      }
    }).catchError((error, st) {
      emit(ErrorGetCardInfoState(error.message.toString()));
    });
  }

  // read card data from mifare ultralight card and get card id
  Future<void> readCardData() async {
    if (await NfcManager.instance.isAvailable()) {
      emit(LoadingReadCardDataState());
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        MifareUltralight? mifareUltralight = MifareUltralight.from(tag);
        if (mifareUltralight != null) {
          emit(SuccessReadCardDataState());
          final data = await mifareUltralight.readPages(pageOffset: 9);
          cardId = utf8.decode(data);

          await getCardInfo(cardId: cardId!).then((value) {
            NfcManager.instance.stopSession();
          });
        } else {
          NfcManager.instance.stopSession();
          emit(ErrorReadCardDataState('برجاء تمرير الكارت مرة أخرى'));
        }
      });
    } else {
      emit(ErrorReadCardDataState('برجاء تفعيل NFC من الإعدادات'));
    }
  }

  // add Order
  Future<bool> addOrder() async {
    internalCode = const Uuid().v1();
    emit(LoadingAddOrderState());
    var result = await HttpHelper.addOrder(
            token: token!,
            internalCode: internalCode!,
            date: DateTime.now(),
            litres: num.parse(benzin80Controller.text),
            deductedPoints: num.parse(benzin80Controller.text),
            cardId: cardId)
        .then((value) {
      if (value.statusCode == 200) {
        emit(SuccessAddOrderState());
        return true;
      } else {
        emit(ErrorAddOrderState('حدث خطأ ما كود الخطأ ${value.statusCode}'));
        return false;
      }
    }).catchError((error, st) {
      emit(ErrorAddOrderState('حدث خطأ ما ${error.message}'));
      return false;
    });
    return Future.value(result);
  }

// confirm order
  Future<bool> confirmOrder({required String otpCode}) async {
    emit(LoadingConfirmOrderState());
    var result = await HttpHelper.confirmOrder(
            token: token!, internalCode: internalCode!, otpCode: otpCode)
        .then((value) {
      if (value.statusCode == 200) {
        emit(SuccessConfirmOrderState());
        return true;
      } else {
        emit(
            ErrorConfirmOrderState('حدث خطأ ما كود الخطأ ${value.statusCode}'));
        return false;
      }
    }).catchError((error, st) {
      emit(ErrorConfirmOrderState('حدث خطأ ما ${error.message}'));
      return false;
    });
    return Future.value(result);
  }

  // minus gas
  void minus(TextEditingController controller) {
    if (controller.text.isEmpty || int.parse(controller.text) == 0) {
      return;
    }
    controller.text = (int.parse(controller.text) - 1).toString();
  }

  // plus gas with max 100
  void plus(TextEditingController controller, int max) {
    if (controller.text.isEmpty) {
      controller.text = '1';
      return;
    }
    if (int.parse(controller.text) == max) {
      return;
    }
    controller.text = (int.parse(controller.text) + 1).toString();
  }

  // on change gas value cant exceed max value

  void onChangeGasValue(
      String value, int max, TextEditingController controller) {
    if (value.isEmpty) {
      return;
    }
    if (int.parse(value) >= max) {
      controller.text = max.toString();
    }
  }

  //reset cubit to initial state
  void reset() {
    nameController.clear();
    passwordController.clear();
    benzin80Controller.clear();
    currentCompany = null;
    cardId = null;
    emit(NfcPosInitial());
  }
}
