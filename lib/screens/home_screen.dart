import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/widgets/app_bar/header_app_bar.dart';
import 'package:my_app/widgets/home/product_grid.dart';
import 'package:my_app/widgets/items/search_bar_filter_item.dart';
import '../cubit/product/product_cubit.dart';
import '../cubit/product/product_selection_cubit.dart';
import '../cubit/product/product_state.dart';
import '../widgets/modals/selected_products_modal.dart';

class HomeScreen extends StatelessWidget {
  final String? loginMessage;

  const HomeScreen({super.key, this.loginMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderAppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProductCubit()..fetchProducts()),
          BlocProvider(create: (context) => ProductSelectionCubit()),
        ],
        child: BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        if (loginMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              loginMessage!,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SearchBarFilterItem(),
                        ProductGrid(products: state.products),
                      ],
                    ),
                  ),
                  const SelectedProductsModal(),
                ],
              );
            }
            return const Center(child: Text('No products found'));
          },
        ),
      ),
    );
  }
}
