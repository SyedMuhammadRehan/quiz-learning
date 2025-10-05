
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/user_header.dart';
import '../widgets/category_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == HomeStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Something went wrong',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            }

            if (state.user == null) {
              return const Center(
                child: Text('No user data available'),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                // Determine number of columns based on width
                int crossAxisCount = 1;
                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth >= 768) {
                  crossAxisCount = 2;
                }

                return CustomScrollView(
                  slivers: [
                    // User Header
                    SliverToBoxAdapter(
                      child: UserHeader(user: state.user!),
                    ),

                    // Page Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: Responsive.getPagePadding(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            Text(
                              'Choose a Category',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Select a quiz category to get started',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // Categories - Using Wrap for flexible layout
                    SliverPadding(
                      padding: Responsive.getPagePadding(context),
                      sliver: SliverToBoxAdapter(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: state.categories.map((category) {
                            // Calculate card width based on columns
                            final cardWidth = (constraints.maxWidth - 
                                (Responsive.getPagePadding(context).horizontal) - 
                                (16 * (crossAxisCount - 1))) / crossAxisCount;

                            return SizedBox(
                              width: crossAxisCount == 1 
                                  ? double.infinity 
                                  : cardWidth,
                              child: CategoryCard(
                                category: category,
                                onTap: () {
                                  context.pushNamed(
                                    'countdown',
                                    extra: {
                                      'categoryName': category.name,
                                      'categoryId': category.id,
                                      'difficulty': category.difficulty,
                                    },
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 32),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
