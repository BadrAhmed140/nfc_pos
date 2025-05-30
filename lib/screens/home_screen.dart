import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_pos/blocs/nfc_pos/nfc_pos_cubit.dart';
import 'package:nfc_pos/components/loading_button.dart';
import 'package:nfc_pos/components/nfc_bottom_sheet.dart';
import 'package:nfc_pos/screens/check_out_screen.dart';
import 'package:pinput/pinput.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FlipCardController _flipCardController;
  bool isAccepted = true;
  bool _instructionsVisibility = false;
  double _instructionsObasity = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flipCardController = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _instructionsObasity =
                                _instructionsObasity == 0.0 ? 1.0 : 0.0;
                            if (!_instructionsVisibility) {
                              _instructionsVisibility = true;
                            }
                          });
                        },
                        icon: Icon(
                          Icons.info_outline,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    Image.asset(
                      'assets/images/logo_t3awon.png',
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                //display petrol_station and userId from user model
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      border:
                          Border.all(color: const Color(0xff636466), width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        NfcPosCubit.get(context).currentUser!.petrolStation,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        NfcPosCubit.get(context).currentUser!.userId,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                AnimatedScale(
                  scale: _instructionsObasity,
                  duration: const Duration(milliseconds: 600),
                  onEnd: () {
                    setState(() {
                      if (_instructionsVisibility &&
                          _instructionsObasity == 0.0) {
                        _instructionsVisibility = false;
                      }
                    });
                  },
                  child: Visibility(
                    visible: _instructionsVisibility,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          border: Border.all(
                              color: const Color(0xff636466), width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(
                            'تعليمات الاستخدام :',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          ),
                          Text(
                            '1- قم بالضغط على زر بدء مسح الكارت.\n2- قرب الكارت من الجهاز.\n3- سيتم قراءة الكارت وعرض البيانات.',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            // add bloc consumer to handel state
            BlocConsumer<NfcPosCubit, NfcPosState>(
              builder: (context, state) {
                var nfcPosCubit = NfcPosCubit.get(context);
                var currentCompany = nfcPosCubit.currentCompany;
                return currentCompany == null
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لا توجد بيانات لعرضها',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                            Lottie.asset('assets/lottie/empty.json',
                                height: 200, width: 200),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: currentCompany.active == 1
                                      ? Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer
                                      : Theme.of(context).disabledColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentCompany.companyName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${currentCompany.points} نقطة متبقية',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                                  ),
                                  Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                  Wrap(
                                    children: [
                                      Text(
                                        'المسئول : ${currentCompany.responsible}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      ),
                                      Text(
                                        ' - ${currentCompany.contact}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: GridView(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.2,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  children: [
                                    FlipCard(
                                      controller: _flipCardController,
                                      back: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'بنزين 80',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer),
                                              textAlign: TextAlign.center,
                                            ),
                                            Expanded(
                                                child: Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      nfcPosCubit.minus(nfcPosCubit
                                                          .benzin80Controller);
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove)),
                                                Expanded(
                                                    child: TextField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  onChanged: (value) {
                                                    nfcPosCubit.onChangeGasValue(
                                                        value,
                                                        currentCompany.points,
                                                        nfcPosCubit
                                                            .benzin80Controller);
                                                  },
                                                  controller: nfcPosCubit
                                                      .benzin80Controller,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        '${currentCompany.points} لتر',
                                                  ),
                                                )),
                                                IconButton(
                                                    onPressed: () {
                                                      nfcPosCubit.plus(
                                                          nfcPosCubit
                                                              .benzin80Controller,
                                                          currentCompany
                                                              .points);
                                                    },
                                                    icon:
                                                        const Icon(Icons.add)),
                                              ],
                                            )),
                                            LoadingButton(
                                              onPressed: () async {
                                                if (nfcPosCubit
                                                        .benzin80Controller
                                                        .text
                                                        .isEmpty ||
                                                    int.parse(nfcPosCubit
                                                            .benzin80Controller
                                                            .text) <
                                                        10) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        'الكمية لا تقل عن 10 لتر'),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                  return;
                                                }
                                                await nfcPosCubit
                                                    .addOrder()
                                                    .then((value) {
                                                  if (value) {
                                                    showGeneralDialog(
                                                        context: context,
                                                        pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) =>
                                                            Dialog(
                                                                child:
                                                                    Container(
                                                              height: 200,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  const Text(
                                                                      'ادخل الرقم التاكيدي'),
                                                                  Directionality(
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    child: Pinput(
                                                                        autofocus: true,
                                                                        length: 6,
                                                                        validator: (s) {
                                                                          // return  nfcPosCubit.confirmOrder(otpCode: s)
                                                                          //     ? null
                                                                          //     : 'الكود غير صحيح';
                                                                        },
                                                                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                                                        showCursor: true,
                                                                        onCompleted: (pin) async {
                                                                          showDialog(
                                                                            barrierDismissible:
                                                                                false,
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            ),
                                                                          );
                                                                          nfcPosCubit
                                                                              .confirmOrder(otpCode: pin)
                                                                              .then((value) {
                                                                            Navigator.pop(context);
                                                                            if (value) {
                                                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CheckOutScreen()));
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الكود غير صحيح')));
                                                                            }
                                                                          });
                                                                        }),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            LoadingButton(
                                                                          onPressed:
                                                                              () async {
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم ارسال الكود بنجاح')));
                                                                          },
                                                                          text:
                                                                              'اعادة ارسال الكود',
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            LoadingButton(
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          text:
                                                                              'الغاء',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )));
                                                  }
                                                });
                                              },
                                              text: 'تأكيد',
                                            )
                                          ],
                                        ),
                                      ),
                                      front: MaterialButton(
                                        onPressed: () {
                                          if (currentCompany.active == 1) {
                                            if (currentCompany.points == 0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                          'لا يوجد رصيد لهذا العميل')));
                                            } else {
                                              _flipCardController.toggleCard();
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'هذا العميل غير مفعل')));
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        splashColor: Colors.black38,
                                        highlightColor: Colors.black12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'بنزين 80',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${currentCompany.points} لتر',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      splashColor: Colors.black38,
                                      highlightColor: Colors.black12,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'بنزين 92',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${(currentCompany.points * .7).floor()} لتر',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {},
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      splashColor: Colors.black38,
                                      highlightColor: Colors.black12,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'بنزين 95',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${(currentCompany.points * .5).floor()} لتر',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {},
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      splashColor: Colors.black38,
                                      highlightColor: Colors.black12,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'سولار',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${(currentCompany.points * 1.1).floor()} لتر',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {},
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      );
              },
              listener: (context, state) {},
            ),

            BlocConsumer<NfcPosCubit, NfcPosState>(
              listener: (context, state) {
                if (state is ErrorReadCardDataState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                var nfcPosCubit = NfcPosCubit.get(context);
                return LoadingButton(
                    onPressed: () async {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          builder: (context) {
                            return const NFCBottomSheet(
                                // isAccepted: !isAccepted,
                                );
                          });
                      await nfcPosCubit.readCardData();
                    },
                    text: 'بدء مسح الكارت');
              },
            ),
          ],
        ),
      ),
    ));
  }
}
