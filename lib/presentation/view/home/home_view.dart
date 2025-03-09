import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
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

    return Scaffold(
      backgroundColor: DefaultColorPalette.grey100,
      appBar: AppBar(
        surfaceTintColor: DefaultColorPalette.grey100,
        backgroundColor: DefaultColorPalette.grey100,
        shadowColor: DefaultColorPalette.vanillaBlack,
        elevation: 0,
        leading: const CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.person),
        ),
        actions: [
          pushTradePageIconButton(context),
          pushWalletIconButton(),
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
                  Text(
                    ref
                            .read(authGlobalProvider.notifier)
                            .getCurrentUser
                            ?.email
                            .toString() ??
                        "asfsaf",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CustomSizedBox.hugeGap(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "₺${null}",
                          style: TextStyle(fontSize: 32, color: Colors.black),
                        ),
                        TextSpan(
                          text: ".${null}",
                          style: TextStyle(
                              fontSize: 32, color: DefaultColorPalette.grey400),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_drop_up,
                        color: DefaultColorPalette.vanillaGreen,
                      ),
                      Text("${null}%"),
                    ],
                  ),
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
                  currencies(context, viewModel),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20, // Ekranın soluna hizalama
            child: Row(
              children: [
                // Sol taraf arama çubuğu
                Container(
                  width: MediaQuery.of(context).size.width /
                      2, // Ekranın yarısı kadar genişlik
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color:
                        Colors.white.withOpacity(0.9), // Hafif transparan beyaz
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10.0,
                        offset: Offset(0, 4), // Alt tarafa doğru gölge
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: viewModel.searchBarController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Assets...",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey.shade600),
                    ),
                  ),
                ),
                const SizedBox(
                    width:
                        20), // Arama çubuğu ve ikinci container arasında boşluk
                // Sağ tarafta başka bir container
                Container(
                  width: MediaQuery.of(context).size.width / 3 - 20,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.purple.shade200
                        .withOpacity(1), // Hafif transparan beyaz
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 10.0,
                        offset: Offset(0, 4), // Alt tarafa doğru gölge
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "SWAP",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
              return const SizedBox(); // Önceki kartları gizle
            }
            return Positioned(
              top: -index * 12.0, // Kartların hafif üst üste görünmesi için
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

  SizedBox currencies(BuildContext context, HomeViewModel viewModel) {
    return SizedBox(
      height: ResponsiveSize(context).screenHeight.toPercent(50),
      width: ResponsiveSize(context).screenWidth,
      child: StreamBuilder2(
        streams: StreamTuple2(
            ref.read(appGlobalProvider.notifier).getDataStream ??
                viewModel.getEmptyStream,
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
        color: DefaultColorPalette.grey100,
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

class CustomCardWidget extends StatelessWidget {
  final String title;
  final String description;

  CustomCardWidget({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero, // Card'ın kenar boşluğunun sıfırlanması
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        child: CustomPadding.smallHorizontal(
          widget: SizedBox(
            width: ResponsiveSize(context).screenWidth.toPercent(90),
            height: 125,
            child: CustomPadding.mediumAll(
              widget: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purple.shade50,
                    ),
                    child: Icon(
                      Icons.attach_money_rounded,
                      color: Colors.purple.shade400,
                    ),
                  ),
                  const CustomSizedBox.smallWidth(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Swipe",
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                              description,
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
