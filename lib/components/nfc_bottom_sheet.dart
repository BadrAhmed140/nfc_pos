import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_pos/blocs/nfc_pos/nfc_pos_cubit.dart';

class NFCBottomSheet extends StatefulWidget {
  const NFCBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<NFCBottomSheet> createState() => _NFCBottomSheetState();
}

class _NFCBottomSheetState extends State<NFCBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NfcPosCubit, NfcPosState>(
      listener: (context, state) {
        if (state is SuccessReadCardDataState) {
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
        if (state is ErrorReadCardDataState) {
          NfcPosCubit.get(context).currentCompany = null;
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      },
      builder: (context, state) {
        String currentText;
        String currentState;
        bool isRead;
        bool isRepeat;
        currentText = state is LoadingReadCardDataState
            ? 'جاري قراءة الكارت'
            : state is SuccessReadCardDataState ||
                    state is SuccessGetCardInfoState
                ? 'تم قراءة الكارت بنجاح'
                : state is ErrorReadCardDataState
                    ? 'حدث خطأ اثناء قراءة الكارت'
                    : 'جاري قراءة الكارت';
        currentState = state is LoadingReadCardDataState
            ? 'loading'
            : state is SuccessReadCardDataState ||
                    state is SuccessGetCardInfoState
                ? 'accepted'
                : state is ErrorReadCardDataState
                    ? 'error'
                    : 'loading';
        isRead = state is SuccessReadCardDataState ||
            state is SuccessGetCardInfoState;
        isRepeat = state is LoadingReadCardDataState;

        return Container(
          padding: const EdgeInsets.all(8.0),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Text(currentText)),
              Expanded(
                  child: Lottie.asset(
                'assets/lottie/$currentState.json',
                repeat: isRepeat,
              )),
            ],
          ),
        );
      },
    );
  }
}
