import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Constantes de color extraídas de tu style.css
class AppColors {
  static const primary = Color(0xFF4E54C8);
  static const secondary = Color(0xFF8F94FB);
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF39C12);
  static const danger = Color(0xFFE74C3C);
  static const background = Color(0xFFF5F7FF);
  static const cardColor = Colors.white;
  static const textDark = Color(0xFF333333);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard Ventas',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Estado actual (equivalente a tus variables globales en JS)
  String selectedPeriod = 'year';
  String totalSales = '\$124,580';
  String newCustomers = '1,245';
  String productsSold = '8,742';
  String netProfit = '\$42,350';

  // Datos para el gráfico de barras
  List<double> barChartData = [
    8500,
    10200,
    9300,
    12400,
    15800,
    14300,
    16900,
    18500,
    17400,
    19200,
    21000,
    23500,
  ];

  // Datos fijos de productos (Top Products)
  final List<Map<String, dynamic>> topProducts = [
    {
      'name': 'Laptop Gaming',
      'cat': 'Electrónicos',
      'sales': 1245,
      'rev': 124500,
      'color': AppColors.primary,
    },
    {
      'name': 'Zapatillas',
      'cat': 'Deportes',
      'sales': 987,
      'rev': 78960,
      'color': AppColors.danger,
    },
    {
      'name': 'Smartphone Pro',
      'cat': 'Electrónicos',
      'sales': 856,
      'rev': 102720,
      'color': AppColors.primary,
    },
    {
      'name': 'Abrigo Invierno',
      'cat': 'Ropa',
      'sales': 723,
      'rev': 50610,
      'color': AppColors.success,
    },
  ];

  // Lógica equivalente a updateDashboardData(period) en JS
  void updateDashboardData(String period) {
    setState(() {
      selectedPeriod = period;
      switch (period) {
        case 'month':
          totalSales = '\$12,450';
          newCustomers = '142';
          productsSold = '856';
          netProfit = '\$4,230';
          barChartData = [8500, 10200, 9300, 12400];
          break;
        case 'quarter':
          totalSales = '\$45,680';
          newCustomers = '512';
          productsSold = '3,245';
          netProfit = '\$15,420';
          barChartData = [
            8500,
            10200,
            9300,
            12400,
            15800,
            14300,
            16900,
            18500,
            17400,
          ];
          break;
        case 'year':
          totalSales = '\$124,580';
          newCustomers = '1,245';
          productsSold = '8,742';
          netProfit = '\$42,350';
          barChartData = [
            8500,
            10200,
            9300,
            12400,
            15800,
            14300,
            16900,
            18500,
            17400,
            19200,
            21000,
            23500,
          ];
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard de Ventas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          // Selector de periodo (Dropdown)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              dropdownColor: AppColors.primary,
              value: selectedPeriod,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(), // Quitar línea inferior
              style: const TextStyle(color: Colors.white),
              onChanged: (String? newValue) {
                if (newValue != null) updateDashboardData(newValue);
              },
              items: <String>['month', 'quarter', 'year']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value == 'month'
                            ? 'Último mes'
                            : value == 'quarter'
                            ? 'Trimestre'
                            : 'Año',
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ],
      ),
      drawer: const _SidebarDrawer(), // Sidebar equivalente
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tarjetas de Resumen (Grid 2x2)
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true, // Importante dentro de ScrollView
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              children: [
                _SummaryCard(
                  title: 'Ventas Totales',
                  value: totalSales,
                  icon: Icons.attach_money,
                  color: AppColors.primary,
                ),
                _SummaryCard(
                  title: 'Clientes Nuevos',
                  value: newCustomers,
                  icon: Icons.group,
                  color: AppColors.success,
                ),
                _SummaryCard(
                  title: 'Prod. Vendidos',
                  value: productsSold,
                  icon: Icons.inventory_2,
                  color: AppColors.warning,
                ),
                _SummaryCard(
                  title: 'Ganancia Neta',
                  value: netProfit,
                  icon: Icons.trending_up,
                  color: AppColors.danger,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 2. Gráfico de Barras
            const Text(
              "Ventas por Periodo",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.grey[800]!,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.round().toString(),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Solo mostramos algunas etiquetas para simplificar
                          if (value.toInt() >= 0 &&
                              value.toInt() < barChartData.length) {
                            return Text(
                              (value.toInt() + 1).toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  barGroups: barChartData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: AppColors.primary,
                          width: 16,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Gráfico Circular (Pie Chart)
            const Text(
              "Ventas por Categoría",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: AppColors.primary,
                            value: 35,
                            title: '35%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppColors.success,
                            value: 25,
                            title: '25%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppColors.warning,
                            value: 15,
                            title: '15%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppColors.danger,
                            value: 10,
                            title: '10%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(
                        color: AppColors.primary,
                        text: "Electrónicos",
                      ),
                      _LegendItem(color: AppColors.success, text: "Ropa"),
                      _LegendItem(color: AppColors.warning, text: "Hogar"),
                      _LegendItem(color: AppColors.danger, text: "Deportes"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Tabla de Productos (Usando ListView y Card)
            const Text(
              "Productos Más Vendidos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...topProducts.map(
              (product) => Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: product['color'],
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${product['cat']} • ${product['sales']} ventas",
                  ),
                  trailing: Text(
                    "\$${product['rev']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGETS AUXILIARES ---

// Drawer (Sidebar)
class _SidebarDrawer extends StatelessWidget {
  const _SidebarDrawer();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            accountName: Text("Tienda Ejemplo"),
            accountEmail: Text("admin@tienda.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.store, color: AppColors.primary),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: true,
            selectedColor: AppColors.primary,
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Ventas'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Productos'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clientes'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// Tarjeta de Resumen
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 18,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Item de Leyenda para el PieChart
class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
