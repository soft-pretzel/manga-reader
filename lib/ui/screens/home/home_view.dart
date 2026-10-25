import 'package:flutter/material.dart';

import '../../widgets/error_screen.dart';
import 'home_view_model.dart';
import 'widgets/book_card.dart';
import 'widgets/empty_home_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Home')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.load.execute,
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                if (viewModel.load.running) {
                  return const SizedBox.shrink();
                }
                if (viewModel.load.error) {
                  return ErrorScreen(
                    function: viewModel.load.execute,
                    text: 'Error loading Home',
                  );
                }
                if (viewModel.inProgressBooks.isEmpty) {
                  return EmptyHomeScreen();
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Padding(
                          padding: const .all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text('Continue Reading'),
                                    SizedBox(height: 12),
                                    Expanded(
                                      child: ListView(
                                        // clipBehavior: .antiAlias,
                                        scrollDirection: .horizontal,
                                        children: [
                                          for (final book
                                              in viewModel.inProgressBooks)
                                            BookCard(
                                              book: book,
                                              viewModel: viewModel,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox.shrink()),
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
    );
  }
}
