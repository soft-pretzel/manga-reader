import 'package:flutter/widgets.dart';

import '../reader_view_model.dart';

class PagePreview extends StatelessWidget {
  final PageController pageController;
  final ReaderViewModel viewModel;

  const PagePreview({
    super.key,
    required this.pageController,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController(
      keepScrollOffset: false,
      initialScrollOffset: viewModel.book.currentPage.toDouble() - 1,
    );
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return SizedBox(
          height: 144,
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              return Padding(
                padding: const .symmetric(horizontal: 4),
                child: Image.memory(viewModel.pages[index]!),
              );
            },
            itemCount: viewModel.pages.length,
            padding: const .only(bottom: 8),
            reverse: viewModel.readingDirection == .rightToLeft,
            scrollDirection: .horizontal,
          ),
        );
      },
    );
  }
}
