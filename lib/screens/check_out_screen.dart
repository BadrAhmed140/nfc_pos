import 'package:flutter/material.dart';
import 'package:nfc_pos/blocs/nfc_pos/nfc_pos_cubit.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nfcCubit = NfcPosCubit.get(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'تم تنفيذ العملية بنجاح',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FittedBox(
                      child: Text(
                        '${nfcCubit.internalCode}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'التاريخ:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(DateTime.now().toIso8601String().split('T')[0])
                      ],
                    ),
                    // wrap for time with row and space between
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الوقت:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                            '${DateTime.now().toIso8601String().split('T')[1].split('.')[0]}')
                      ],
                    ),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'البيان',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Center(
                          child: Text(
                            'تفويل عدد ${nfcCubit.benzin80Controller.text} لتر بنزين 80',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('النقاط المخصومة:',
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text(nfcCubit.benzin80Controller.text),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('النقاط المتبقية:',
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text(
                            '${nfcCubit.currentCompany!.points - num.parse(nfcCubit.benzin80Controller.text)}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  nfcCubit.reset();
                  Navigator.pop(context);
                },
                child: const Text('العودة إلى القائمة الرئيسية')),
            ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('تم اعادة طباعة الفاتورة بنجاح'),
                  ));
                },
                child: const Text('اعادة طباعة الفاتورة')),
          ],
        ),
      )),
    );
  }
}
