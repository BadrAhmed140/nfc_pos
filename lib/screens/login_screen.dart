import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_pos/blocs/nfc_pos/nfc_pos_cubit.dart';
import 'package:nfc_pos/components/loading_button.dart';
import 'package:nfc_pos/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var companyCubit = NfcPosCubit.get(context);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Lottie.asset(
                  'assets/lottie/login.json',
                  height: MediaQuery.of(context).size.height / 2.2,
                ),
                Form(
                  key: companyCubit.loginFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: companyCubit.nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل اسم المستخدم';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'اسم المستخدم',
                            prefixIcon: Icon(Icons.person)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: companyCubit.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل كلمة المرور';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'كلمة المرور',
                            prefixIcon: Icon(Icons.lock)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocConsumer<NfcPosCubit, NfcPosState>(
                        listener: (context, state) {
                          if (state is SuccessLoginState) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          }

                          if (state is ErrorLoginState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                              width: double.infinity,
                              child: LoadingButton(
                                text: 'تسجيل الدخول',
                                onPressed: () async {
                                  if (companyCubit.loginFormKey.currentState!
                                      .validate()) {
                                    await companyCubit.login(
                                        name: companyCubit.nameController.text,
                                        passWord: companyCubit
                                            .passwordController.text);
                                  }
                                },
                              ));
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('هل تواجه مشكلة؟'),
                          TextButton(
                            onPressed: () async {},
                            child: const Text('تواصل معنا'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
