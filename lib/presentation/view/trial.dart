import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/data/model/web/direction_model.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/currency_card_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/currency_card_widget.dart';
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
        title: Text(
          "PaRota",
          style: TextStyle(
            fontFamily: "Manrobe",
            fontWeight: FontWeight.bold,
            color: DefaultColorPalette.mainTextBlack,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 8,
                itemBuilder: (context, index) {
                  CurrencyWidgetEntity currency = CurrencyWidgetEntity(
                      alis: "25.00",
                      satis: "24.29",
                      code: "TRY",
                      dir: Direction(
                        alisDir: "up",
                        satisDir: "down",
                      ),
                      name: 'Türk Lirası',
                      entity: CurrencyEntity(
                          code: "code",
                          alis: "25",
                          satis: "25",
                          tarih: "tarih",
                          dir: Direction(alisDir: "up", satisDir: "down"),
                          dusuk: "24.0",
                          yuksek: "22.0",
                          kapanis: "25.0"));
                  return CurrencyCardWidget(
                    currency: currency,
                    onTap: () {},
                  );
                },
              ),
                
            ),
          ),
        ),
      ),
    );
  }
}
