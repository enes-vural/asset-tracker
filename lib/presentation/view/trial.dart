import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TrialView extends ConsumerStatefulWidget {
  const TrialView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrialViewState();
}

class _TrialViewState extends ConsumerState<TrialView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C1810),
              Color(0xFF5D4E37),
              Color(0xFF8B4513),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_cafe,
                            size: 60,
                            color: Colors.orange[300],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'NARGILE KAFE',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Dijital Menü',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange[300],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Menu Categories
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildCategoryCard(
                        icon: Icons.local_fire_department,
                        title: 'Sıcak İçecekler',
                        color: Colors.red,
                        delay: 0,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategoryPage(
                              title: 'Sıcak İçecekler',
                              subCategories: _getHotDrinksCategories(),
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      _buildCategoryCard(
                        icon: Icons.ac_unit,
                        title: 'Soğuk İçecekler',
                        color: Colors.blue,
                        delay: 200,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategoryPage(
                              title: 'Soğuk İçecekler',
                              subCategories: _getColdDrinksCategories(),
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      _buildCategoryCard(
                        icon: Icons.restaurant,
                        title: 'Yemekler',
                        color: Colors.green,
                        delay: 400,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategoryPage(
                              title: 'Yemekler',
                              subCategories: _getFoodCategories(),
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      _buildCategoryCard(
                        icon: Icons.smoke_free,
                        title: 'Nargileler',
                        color: Colors.purple,
                        delay: 600,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategoryPage(
                              title: 'Nargileler',
                              subCategories: _getHookahCategories(),
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '🌟 Lezzetli anların adresi 🌟',
                  style: TextStyle(
                    color: Colors.orange[300],
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required Color color,
    required int delay,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      //delay: Duration(milliseconds: delay),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<SubCategory> _getHotDrinksCategories() {
    return [
      SubCategory(
        name: 'Çaylar',
        icon: Icons.local_cafe,
        items: [
          MenuItem('Türk Çayı', '15 ₺', 'Geleneksel demli çay',
              'https://cdn.pixabay.com/photo/2017/05/12/08/29/coffee-2306471_960_720.jpg'),
          MenuItem('Earl Grey', '20 ₺', 'Bergamot aromalı çay',
              'https://cdn.pixabay.com/photo/2016/11/06/11/15/cup-1801598_960_720.jpg'),
          MenuItem('Yeşil Çay', '18 ₺', 'Antioxidan bakımından zengin',
              'https://cdn.pixabay.com/photo/2019/11/26/12/25/cup-4653017_960_720.jpg'),
          MenuItem('Bitki Çayı', '22 ₺', 'Çeşitli bitki karışımları',
              'https://cdn.pixabay.com/photo/2017/04/08/00/56/tea-2211331_960_720.jpg'),
          MenuItem('Kış Çayı', '25 ₺', 'Tarçın ve karanfil aromalı',
              'https://cdn.pixabay.com/photo/2016/11/29/12/45/beverage-1869598_960_720.jpg'),
          MenuItem('Apple Çayı', '24 ₺', 'Elma aromalı sıcak çay',
              'https://cdn.pixabay.com/photo/2017/01/14/12/48/tea-1979125_960_720.jpg'),
          MenuItem('Jasmin Çayı', '26 ₺', 'Yasemin çiçeği aromalı',
              'https://cdn.pixabay.com/photo/2016/11/18/22/25/tea-1837379_960_720.jpg'),
          MenuItem('Oolong Çayı', '28 ₺', 'Geleneksel Çin çayı',
              'https://cdn.pixabay.com/photo/2017/02/07/16/47/china-2048540_960_720.jpg'),
          MenuItem('Mate Çayı', '30 ₺', 'Güney Amerika çayı',
              'https://cdn.pixabay.com/photo/2018/04/29/21/31/yerba-mate-3359776_960_720.jpg'),
          MenuItem('Rooibos Çayı', '27 ₺', 'Kafeinsiz kırmızı çay',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Papatya Çayı', '23 ₺', 'Rahatlama içecegi',
              'https://cdn.pixabay.com/photo/2016/08/23/15/52/fresh-1614359_960_720.jpg'),
          MenuItem('Kuşburnu Çayı', '21 ₺', 'C vitamini açısından zengin',
              'https://cdn.pixabay.com/photo/2017/09/04/18/39/tea-2714572_960_720.jpg'),
        ],
      ),
      SubCategory(
        name: 'Kahveler',
        icon: Icons.coffee,
        items: [
          MenuItem('Espresso', '25 ₺', 'İtalyan usulü espresso',
              'https://cdn.pixabay.com/photo/2016/11/29/09/00/doughnuts-1868573_960_720.jpg'),
          MenuItem('Americano', '30 ₺', 'Sulandırılmış espresso',
              'https://cdn.pixabay.com/photo/2017/05/12/08/29/coffee-2306471_960_720.jpg'),
          MenuItem('Cappuccino', '35 ₺', 'Süt köpüğü ile servis',
              'https://cdn.pixabay.com/photo/2016/01/02/04/59/coffee-1117933_960_720.jpg'),
          MenuItem('Latte', '38 ₺', 'Kremalı süt kahvesi',
              'https://cdn.pixabay.com/photo/2017/07/31/11/21/people-2557396_960_720.jpg'),
          MenuItem('Türk Kahvesi', '32 ₺', 'Geleneksel Türk kahvesi',
              'https://cdn.pixabay.com/photo/2016/02/29/05/46/coffee-1228139_960_720.jpg'),
          MenuItem('Mocha', '40 ₺', 'Çikolatalı kahve',
              'https://cdn.pixabay.com/photo/2017/05/12/08/29/coffee-2306471_960_720.jpg'),
          MenuItem('Macchiato', '36 ₺', 'İtalyan tarzı lekeli kahve',
              'https://cdn.pixabay.com/photo/2018/01/31/09/57/coffee-3120750_960_720.jpg'),
          MenuItem('Affogato', '42 ₺', 'Dondurmalı espresso',
              'https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_960_720.jpg'),
          MenuItem('Cortado', '34 ₺', 'İspanyol tarzı süt kahvesi',
              'https://cdn.pixabay.com/photo/2016/11/18/22/25/tea-1837379_960_720.jpg'),
          MenuItem('Flat White', '37 ₺', 'Avustralya tarzı kahve',
              'https://cdn.pixabay.com/photo/2017/01/14/12/48/tea-1979125_960_720.jpg'),
          MenuItem('French Press', '33 ₺', 'Fransız usulü demli kahve',
              'https://cdn.pixabay.com/photo/2015/11/07/11/22/coffee-1031139_960_720.jpg'),
          MenuItem('Cold Brew', '39 ₺', 'Soğuk demleme kahve',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
        ],
      ),
      SubCategory(
        name: 'Sıcak Özel İçecekler',
        icon: Icons.local_drink,
        items: [
          MenuItem('Sahlep', '35 ₺', 'Tarçınlı sıcak sahlep',
              'https://cdn.pixabay.com/photo/2017/01/16/15/24/hot-chocolate-1984012_960_720.jpg'),
          MenuItem('Sıcak Çikolata', '40 ₺', 'Kremalı sıcak çikolata',
              'https://cdn.pixabay.com/photo/2016/12/26/17/28/spur-1932406_960_720.jpg'),
          MenuItem('Chai Latte', '42 ₺', 'Baharatlı süt çayı',
              'https://cdn.pixabay.com/photo/2017/05/12/08/29/coffee-2306471_960_720.jpg'),
          MenuItem('Salep Latte', '45 ₺', 'Modern salep karışımı',
              'https://cdn.pixabay.com/photo/2017/01/16/15/24/hot-chocolate-1984012_960_720.jpg'),
          MenuItem('Golden Milk', '48 ₺', 'Zerdeçallı altın süt',
              'https://cdn.pixabay.com/photo/2017/02/15/10/39/salad-2068220_960_720.jpg'),
          MenuItem('Matcha Latte', '50 ₺', 'Yeşil çay tozu latte',
              'https://cdn.pixabay.com/photo/2019/11/26/12/25/cup-4653017_960_720.jpg'),
          MenuItem('Bonbon Çikolata', '43 ₺', 'Karamelli sıcak çikolata',
              'https://cdn.pixabay.com/photo/2016/12/26/17/28/spur-1932406_960_720.jpg'),
          MenuItem('Beyaz Çikolata', '44 ₺', 'Kremsi beyaz çikolata',
              'https://cdn.pixabay.com/photo/2017/01/16/15/24/hot-chocolate-1984012_960_720.jpg'),
          MenuItem('Ballı Süt', '32 ₺', 'Geleneksel ballı sıcak süt',
              'https://cdn.pixabay.com/photo/2016/08/23/15/52/fresh-1614359_960_720.jpg'),
          MenuItem('Sıcak Elma Şarabı', '55 ₺', 'Baharatlı sıcak elma içeceği',
              'https://cdn.pixabay.com/photo/2017/12/10/14/47/pizignan-3010455_960_720.jpg'),
          MenuItem('Mint Hot Chocolate', '46 ₺', 'Naneli sıcak çikolata',
              'https://cdn.pixabay.com/photo/2016/12/26/17/28/spur-1932406_960_720.jpg'),
          MenuItem('Cinnamon Latte', '41 ₺', 'Tarçınlı latte',
              'https://cdn.pixabay.com/photo/2017/05/12/08/29/coffee-2306471_960_720.jpg'),
        ],
      ),
    ];
  }

  List<SubCategory> _getColdDrinksCategories() {
    return [
      SubCategory(
        name: 'Gazlı İçecekler',
        icon: Icons.local_drink,
        items: [
          MenuItem('Kola', '20 ₺', 'Soğuk gazlı kola',
              'https://cdn.pixabay.com/photo/2016/01/02/17/09/cola-1119776_960_720.jpg'),
          MenuItem('Fanta', '20 ₺', 'Portakal aromalı',
              'https://cdn.pixabay.com/photo/2017/06/06/22/37/drink-2378396_960_720.jpg'),
          MenuItem('Sprite', '20 ₺', 'Limon aromalı gazoz',
              'https://cdn.pixabay.com/photo/2017/06/06/22/37/drink-2378396_960_720.jpg'),
          MenuItem('Soda', '15 ₺', 'Sade soda',
              'https://cdn.pixabay.com/photo/2017/06/06/22/37/drink-2378396_960_720.jpg'),
          MenuItem('7Up', '20 ₺', 'Limon-lime gazlı içecek',
              'https://cdn.pixabay.com/photo/2016/08/05/10/00/soft-drink-1571742_960_720.jpg'),
          MenuItem('Tonic Water', '22 ₺', 'Klasik tonik su',
              'https://cdn.pixabay.com/photo/2017/06/06/22/37/drink-2378396_960_720.jpg'),
          MenuItem('Ginger Ale', '25 ₺', 'Zencefil aromalı gazoz',
              'https://cdn.pixabay.com/photo/2016/08/05/10/00/soft-drink-1571742_960_720.jpg'),
          MenuItem('Club Soda', '18 ₺', 'Mineralli soda',
              'https://cdn.pixabay.com/photo/2017/06/06/22/37/drink-2378396_960_720.jpg'),
          MenuItem('Energy Drink', '30 ₺', 'Enerji içeceği',
              'https://cdn.pixabay.com/photo/2016/01/02/17/09/cola-1119776_960_720.jpg'),
          MenuItem('Diet Kola', '20 ₺', 'Şekersiz kola',
              'https://cdn.pixabay.com/photo/2016/01/02/17/09/cola-1119776_960_720.jpg'),
          MenuItem('Limonata', '25 ₺', 'Ev yapımı limonata',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Portakal Gazoz', '23 ₺', 'Türk usulü portakal gazoz',
              'https://cdn.pixabay.com/photo/2017/06/06/22/37/drink-2378396_960_720.jpg'),
        ],
      ),
      SubCategory(
        name: 'Meyve Suları',
        icon: Icons.local_bar,
        items: [
          MenuItem('Portakal Suyu', '25 ₺', 'Taze sıkılmış portakal',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Elma Suyu', '25 ₺', 'Doğal elma suyu',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Karışık Meyve', '30 ₺', 'Mevsim meyveleri karışımı',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Nar Suyu', '35 ₺', 'Taze nar suyu',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Vişne Suyu', '28 ₺', 'Ekşi vişne suyu',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Şeftali Suyu', '26 ₺', 'Tatlı şeftali suyu',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Ananas Suyu', '32 ₺', 'Tropikal ananas suyu',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Mango Suyu', '34 ₺', 'Egzotik mango suyu',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Üzüm Suyu', '24 ₺', 'Taze üzüm suyu',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Kayısı Suyu', '29 ₺', 'Yumuşak kayısı suyu',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Cranberry Suyu', '31 ₺', 'Kırmızı yaban mersini',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Limon Suyu', '22 ₺', 'Taze sıkılmış limon',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
        ],
      ),
      SubCategory(
        name: 'Milkshake & Smoothie',
        icon: Icons.icecream,
        items: [
          MenuItem('Çilek Milkshake', '40 ₺', 'Çilek aromalı milkshake',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Vanilyalı Milkshake', '40 ₺', 'Vanilya aromalı',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Muz Smoothie', '45 ₺', 'Muz ve süt karışımı',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Berry Smoothie', '48 ₺', 'Karışık meyve smoothie',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Çikolatalı Milkshake', '42 ₺', 'Çikolata aromalı milkshake',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Oreo Milkshake', '45 ₺', 'Oreo bisküvili milkshake',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Mango Smoothie', '50 ₺', 'Egzotik mango smoothie',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Avokado Smoothie', '52 ₺', 'Kremsi avokado smoothie',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Protein Smoothie', '55 ₺', 'Protein tozu ile smoothie',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Green Smoothie', '48 ₺', 'Yeşil yapraklar ve meyve',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
          MenuItem('Kafe Milkshake', '46 ₺', 'Kahve aromalı milkshake',
              'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_960_720.jpg'),
          MenuItem('Karamel Milkshake', '44 ₺', 'Karamel soslu milkshake',
              'https://cdn.pixabay.com/photo/2017/08/04/09/13/drink-2579300_960_720.jpg'),
        ],
      ),
    ];
  }

  List<SubCategory> _getFoodCategories() {
    return [
      SubCategory(
        name: 'Ana Yemekler',
        icon: Icons.restaurant_menu,
        items: [
          MenuItem('Döner Porsiyon', '65 ₺', 'Et döner porsiyon',
              'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400'),
          MenuItem('Tavuk Döner', '60 ₺', 'Tavuk döner porsiyon',
              'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400'),
          MenuItem('Izgara Köfte', '70 ₺', 'Közde pişmiş köfte',
              'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=400'),
          MenuItem('Tavuk Şiş', '75 ₺', 'Marineli tavuk şiş',
              'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400'),
        ],
      ),
      SubCategory(
        name: 'Pideler',
        icon: Icons.local_pizza,
        items: [
          MenuItem('Kaşarlı Pide', '45 ₺', 'Kaşar peynirli pide',
              'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400'),
          MenuItem('Kıymalı Pide', '55 ₺', 'Kıyma ve kaşarlı',
              'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=400'),
          MenuItem('Karışık Pide', '65 ₺', 'Et, sucuk, kaşar',
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400'),
          MenuItem('Lahmacun', '35 ₺', 'İnce hamur lahmacun',
              'https://images.unsplash.com/photo-1565299585323-38174c5b8eff?w=400'),
        ],
      ),
      SubCategory(
        name: 'Atıştırmalıklar',
        icon: Icons.fastfood,
        items: [
          MenuItem('Patates Kızartması', '25 ₺', 'Çıtır patates kızartması',
              'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400'),
          MenuItem('Soğan Halkası', '30 ₺', 'Çıtır soğan halkaları',
              'https://images.unsplash.com/photo-1639024471283-03518883512d?w=400'),
          MenuItem('Mozzarella Stick', '35 ₺', 'Peynir çubukları',
              'https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?w=400'),
          MenuItem('Çerez Tabağı', '40 ₺', 'Karışık kuruyemiş',
              'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=400'),
        ],
      ),
    ];
  }

  List<SubCategory> _getHookahCategories() {
    return [
      SubCategory(
        name: 'Meyve Aromaları',
        icon: Icons.local_florist,
        items: [
          MenuItem('Elma', '80 ₺', 'Taze elma aroması',
              'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=400'),
          MenuItem('Şeftali', '85 ₺', 'Tatlı şeftali aroması',
              'https://images.unsplash.com/photo-1629828874514-d8e1c5c4b611?w=400'),
          MenuItem('Çilek', '85 ₺', 'Taze çilek aroması',
              'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400'),
          MenuItem('Karpuz', '85 ₺', 'Serinletici karpuz',
              'https://images.unsplash.com/photo-1587049633312-d628ae50a8ae?w=400'),
          MenuItem('Üzüm', '90 ₺', 'Tatlı üzüm aroması',
              'https://images.unsplash.com/photo-1537640538966-79f369143715?w=400'),
        ],
      ),
      SubCategory(
        name: 'Nane & Serinletici',
        icon: Icons.ac_unit,
        items: [
          MenuItem('Nane', '80 ₺', 'Saf nane aroması',
              'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=400'),
          MenuItem('Nane-Limon', '85 ₺', 'Nane limon karışımı',
              'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400'),
          MenuItem('Ice Blue', '90 ₺', 'Serinletici buz aroması',
              'https://images.unsplash.com/photo-1544988503-4ad4dde78695?w=400'),
          MenuItem('Mentol', '85 ₺', 'Güçlü mentol aroması',
              'https://images.unsplash.com/photo-1544988503-4ad4dde78695?w=400'),
        ],
      ),
      SubCategory(
        name: 'Özel Karışımlar',
        icon: Icons.stars,
        items: [
          MenuItem('Cappuccino', '95 ₺', 'Kahve aromalı nargile',
              'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400'),
          MenuItem('Love 66', '100 ₺', 'Özel karışım aroma',
              'https://images.unsplash.com/photo-1544988503-4ad4dde78695?w=400'),
          MenuItem('Tropical Mix', '95 ₺', 'Tropikal meyve karışımı',
              'https://images.unsplash.com/photo-1544988503-4ad4dde78695?w=400'),
          MenuItem('Double Apple', '90 ₺', 'Çifte elma aroması',
              'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=400'),
        ],
      ),
    ];
  }
}

class SubCategory {
  final String name;
  final IconData icon;
  final List<MenuItem> items;

  SubCategory({required this.name, required this.icon, required this.items});
}

class MenuItem {
  final String name;
  final String price;
  final String description;
  final String imageUrl;

  MenuItem(this.name, this.price, this.description, this.imageUrl);
}

class SubCategoryPage extends StatefulWidget {
  final String title;
  final List<SubCategory> subCategories;
  final Color color;

  SubCategoryPage({
    required this.title,
    required this.subCategories,
    required this.color,
  });

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.color.withOpacity(0.8),
              widget.color.withOpacity(0.4),
              const Color(0xFF2C1810),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Sub Categories Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: widget.subCategories.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final itemAnimation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                index * (1.0 / widget.subCategories.length),
                                (index + 1) *
                                    (1.0 / widget.subCategories.length),
                                curve: Curves.easeOut,
                              ),
                            ),
                          );

                          return Transform.scale(
                            scale: itemAnimation.value,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuItemsPage(
                                    title: widget.subCategories[index].name,
                                    items: widget.subCategories[index].items,
                                    color: widget.color,
                                  ),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      widget.subCategories[index].icon,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.subCategories[index].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${widget.subCategories[index].items.length} ürün',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemsPage extends StatefulWidget {
  final String title;
  final List<MenuItem> items;
  final Color color;

  MenuItemsPage({
    required this.title,
    required this.items,
    required this.color,
  });

  @override
  _MenuItemsPageState createState() => _MenuItemsPageState();
}

class _MenuItemsPageState extends State<MenuItemsPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.color.withOpacity(0.8),
              widget.color.withOpacity(0.4),
              const Color(0xFF2C1810),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final itemAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              index * (1.0 / widget.items.length),
                              (index + 1) * (1.0 / widget.items.length),
                              curve: Curves.easeOut,
                            ),
                          ),
                        );

                        return Transform.translate(
                          offset: Offset(
                            0,
                            50 * (1 - itemAnimation.value),
                          ),
                          child: Opacity(
                            opacity: itemAnimation.value,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      child: Image.network(
                                        widget.items[index].imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color:
                                                widget.color.withOpacity(0.3),
                                            child: Icon(
                                              Icons.image,
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              size: 40,
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color:
                                                widget.color.withOpacity(0.3),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  
                                  // Product Details
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  widget.items[index].name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: widget.color,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Text(
                                                  widget.items[index].price,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            widget.items[index].description,
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: 14,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
