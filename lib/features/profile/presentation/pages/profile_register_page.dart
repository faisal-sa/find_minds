import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/di/service_locator.dart';
import 'package:graduation_project/core/usecasesAbstract/no_params.dart';
import 'package:graduation_project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:graduation_project/features/profile/presentation/cubit/profile_cubit.dart';

class ProfileRegisterPage extends StatelessWidget {
  //move the controllers to cubit so you can close them
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ProfileRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text("Make your Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await serviceLocator.get<AuthCubit>().signOut.call(NoParams());
              if (context.mounted) {
                context.go("/");
              }
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: .all(16),
            child: PageView(
              reverse: false,
              physics: NeverScrollableScrollPhysics(),

              controller: context.read<ProfileCubit>().pageController,
              children: [
                // ContactInformationPage(
                //   nameController: nameController,
                //   locationController: locationController,
                //   emailController: emailController,
                //   phoneController: phoneController,
                // ),
                // ExperiencesPage(),
                // AboutMePage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
