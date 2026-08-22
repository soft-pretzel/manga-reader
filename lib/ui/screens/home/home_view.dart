import 'package:flutter/material.dart';

import 'home_view_model.dart';
import 'widgets/book_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Home')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.viewModel.load.execute,
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (widget.viewModel.load.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        Text('Error loading Home'),
                        TextButton(
                          onPressed: () {
                            widget.viewModel.load.execute();
                          },
                          child: Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                return child!;
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  if (widget.viewModel.inProgressBooks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            color: Theme.of(context).colorScheme.primary,
                            size: 64,
                          ),
                          SizedBox(height: 12),
                          Text('No in-progress books'),
                          TextButton(
                            onPressed: widget.viewModel.load.execute,
                            child: Text('Reload'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text('Continue Reading'),
                          ),
                          SizedBox(
                            height: 600,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (final book
                                    in widget.viewModel.inProgressBooks)
                                  BookCard(book: book),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
