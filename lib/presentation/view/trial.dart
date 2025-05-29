import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TrialView extends ConsumerStatefulWidget {
  const TrialView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrialViewState();
}

class _TrialViewState extends ConsumerState<TrialView> with ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdayController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Create your account',
                    style: TextStyle(
                      color: Color.fromRGBO(17, 20, 22, 1),
                      fontFamily: 'Manrope',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.27,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Email Field
                AuthFormWidget.email(
                  emailController: null,
                  emailValidator: null,
                  hasTitle: true,
                  hasLabel: false,
                ),
                SizedBox(height: 16),

                AuthFormWidget.password(
                  passwordController: null,
                  passwordValidator: null,
                  hasTitle: true,
                  hasLabel: false,
                ),

                SizedBox(height: 16),

                // Password Field
                AuthFormWidget.firstName(
                  firstNameController: null,
                  firstNameValidator: null,
                  hasTitle: true,
                  hasLabel: false,
                ),

                SizedBox(height: 16),

                // First Name Field
                AuthFormWidget.lastName(
                  lastNameController: null,
                  lastNameValidator: null,
                  hasTitle: true,
                  hasLabel: false,
                ),

                SizedBox(height: 32),

                SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Routers.instance
                          .pushReplaceNamed(context, Routers.registerPath);
                    },
                    child: Text("Register")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
