import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/custom_card_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/home_view_search_field_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/home_view_swap_button_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/search_form_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import '../widgets/currency_card_widget.dart';

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  //async function to call data
  Future<void> callData() async =>
      await ref.read(homeViewModelProvider).getData(ref);

  Future<void> getErrorStream() async => await ref
      .read(homeViewModelProvider)
      .getErrorStream(parentContext: context);

  void initHomeView() =>
      ref.read(homeViewModelProvider.notifier).initHomeView();

  @override
  void initState() {
    //initialize all streams when page starts
    initHomeView();
    callData();
    getErrorStream();
    super.initState();
  }

  List<String> cardTitles = [
    "Start trading with ease!",
    "Secure your assets today!",
    "Welcome to Asset Tracker",
  ];
  List<String> cardTexts = [
    "Start trading with ease!",
    "Secure your assets today!",
    "Finish setting up your wallet to begin swapping seconds",
  ];

  int currentIndex = 0;

  void removeCard() {
    setState(() {
      if (currentIndex < 2) {
        currentIndex++;
        print(currentIndex);
      } else {
        currentIndex = 0; // Baştan başlat
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider);
    final appGlobal = ref.watch(appGlobalProvider.notifier);
    return Scaffold(
      backgroundColor: DefaultColorPalette.grey100,
      appBar: AppBar(
        surfaceTintColor: DefaultColorPalette.grey100,
        backgroundColor: DefaultColorPalette.grey100,
        shadowColor: DefaultColorPalette.vanillaBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.person),
        ),
        actions: [
          exitAppIconButton(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: CustomPadding.largeHorizontal(
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _userEmailTextWidget(),
                  const CustomSizedBox.hugeGap(),
                  _balanceTextWidget(ref
                      .watch(appGlobalProvider.notifier)
                      .getUserData
                      ?.latestBalance
                      .toString()),
                  _balanceProfitTextWidget(ref, false),
                  // StreamBuilder(
                  //     stream: appGlobal.getDataStream,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState !=
                  //           ConnectionState.active) {
                  //         return _balanceProfitTextWidget(ref, true);
                  //       }

                  //       if (!snapshot.hasData) {
                  //         return _balanceProfitTextWidget(ref, true);
                  //       }
                  //       //user alım yaptıktan sonra data tekrar yenilenmeli global provider tekrar tetiklenecek unutma
                  //       List<CurrencyEntity>? data = snapshot.data;

                  //       viewModel.calculateProfitBalance(ref, data);
                  //       return _balanceProfitTextWidget(ref, true);
                  //     }),
                  const CustomSizedBox.hugeGap(),
                  Row(
                    children: [
                      tabBarIcon(Icons.wallet),
                      const CustomSizedBox.mediumWidth(),
                      tabBarIcon(Icons.send),
                      const CustomSizedBox.mediumWidth(),
                      tabBarIcon(Icons.download_rounded),
                      const CustomSizedBox.mediumWidth(),
                      tabBarIcon(Icons.qr_code_2_rounded)
                    ],
                  ),
                  const CustomSizedBox.hugeGap(),
                  CardWidgets(),
                  const CustomSizedBox.smallGap(),
                  exporeAssetsText(),
                  currencies(context, viewModel, appGlobal),
                  const CustomSizedBox.hugeGap(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Row(
              children: [
                HomeViewSearchFieldWidget(viewModel: viewModel),
                const CustomSizedBox.mediumWidth(),
                const HomeViewSwapButtonWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text _userEmailTextWidget() {
    return Text(
      ref.read(authGlobalProvider.notifier).getCurrentUser?.email.toString() ??
          DefaultLocalStrings.emptyText,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Row _balanceProfitTextWidget(WidgetRef ref, bool isLoading) {
    return Row(
      children: [
        const Icon(
          Icons.arrow_drop_up,
          color: DefaultColorPalette.vanillaGreen,
        ),
        isLoading
            ? const Text("0.00%")
            : Text(
                "${ref.watch(appGlobalProvider.notifier).getUserData?.profit}%"),
      ],
    );
  }

Text _balanceTextWidget(String? balance) {
    if (balance == null || balance.isEmpty) balance = "0.00";

    // Ondalık ayırma
    List<String> parts = balance.split(".");
    String wholePart = parts[0]; // Tam sayı kısmı
    String fractionPart = parts.length > 1 ? parts[1] : "00"; // Küsurat kısmı

    // Küsurat kısmını 3 karakterle sınırlandır
    fractionPart =
        fractionPart.length > 2 ? fractionPart.substring(0, 2) : fractionPart;

    // Üçerli bölüp noktalama
    String formattedWholePart = wholePart.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "₺$formattedWholePart",
            style: CustomTextStyle.balanceTextStyle(false),
          ),
          TextSpan(
            text: ",$fractionPart",
            style: CustomTextStyle.balanceTextStyle(true),
          ),
        ],
      ),
    );
  }


  Text exporeAssetsText() {
    return Text(
      "Explore Assets",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 15,
      ),
    );
  }

  SizedBox CardWidgets() {
    return SizedBox(
      height: 150,
      width: 600,
      child: Stack(
        children: List.generate(
          cardTexts.length,
          (index) {
            if (index < currentIndex) {
              return const SizedBox();
            }
            return Positioned(
              top: -index * 12.0,
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) => removeCard(),
                child: CustomCardWidget(
                  title: cardTitles[currentIndex],
                  description: cardTexts[currentIndex],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container tabBarIcon(IconData icon) {
    return Container(
      height: 60,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        icon,
        color: Colors.purple.shade500,
        size: 32.0,
      ),
    );
  }

  SizedBox currencies(
      BuildContext context, HomeViewModel viewModel, appGlobal) {
    return SizedBox(
      height: ResponsiveSize(context).screenHeight.toPercent(50),
      width: ResponsiveSize(context).screenWidth,
      child: StreamBuilder2(
        streams: StreamTuple2(
            appGlobal.getDataStream ?? viewModel.getEmptyStream,
            viewModel.searchBarStreamController ?? viewModel.getEmptyStream),
        initialData: InitialDataTuple2(null, null),
        builder: (context, snapshots) {
          // Stream henüz aktif değilse veya veriler yoksa, loading widget'ı göster
          if (snapshots.snapshot1.connectionState != ConnectionState.active) {
            return loadingIndicatorWidget();
          }

          if (!snapshots.snapshot1.hasData ||
              snapshots.snapshot1.data?[0] == null) {
            return loadingTextWidget();
          }

          List<CurrencyEntity>? data = snapshots.snapshot1.data;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //the reason why we dont give param as data instead of snapshots.snapshot1.data is that
            //you can not call providers during build
            //so we calculate profit after widget build
            //and our data is changing below with our filter chars.
            //so we need to calculate profit after data is filtered
            //if we directly use calculateProfitBalance(data) it will fetch filtered data by keyboard and miscalculate profit.
            viewModel.calculateProfitBalance(ref, snapshots.snapshot1.data);
          });

          data = viewModel.filterCurrencyData(
              data, snapshots.snapshot2.data ?? DefaultLocalStrings.emptyText);
          // İkinci stream'in verisini al (Search bar'dan gelen veri)

          // Güncellenmiş verileri kullanarak listview'i render et
          return ListView.builder(
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) {
              CurrencyWidgetEntity currency =
                  CurrencyWidgetEntity.fromCurrency(data![index]);
              return CurrencyCardWidget(
                currency: currency,
                onTap: () {
                  viewModel.routeTradePage(context, currency.entity);
                },
              );
            },
          );
        },
      ),
    );
  }

  CustomPadding searchBar(HomeViewModel viewModel) {
    return CustomPadding.mediumTop(
      widget: SearchBarWidget(
        searchBarController: viewModel.searchBarController,
        onChangedFn: null,
      ),
    );
  }

  IconButton exitAppIconButton() => IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.exit_to_app,
        color: DefaultColorPalette.grey500,
      ));

  IconButton pushWalletIconButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.wallet,
        color: DefaultColorPalette.grey400,
      ),
    );
  }

  IconButton pushTradePageIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Routers.instance.pushWithInfo(
          context,
          TradeRoute(currecyCode: DefaultLocalStrings.emptyText),
        );
      },
      icon: Icon(
        Icons.attach_money,
        color: DefaultColorPalette.grey400,
      ),
    );
  }

  Center loadingTextWidget() => Center(child: Text(LocaleKeys.home_wait.tr()));
  Center loadingIndicatorWidget() =>
      const Center(child: CircularProgressIndicator());
}
