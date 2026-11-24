import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../data/models/opds_feed.dart';
import '../../../../routing/routes.dart';
import '../library_view_model.dart';

class OpdsGridTile extends StatelessWidget {
  final OpdsFeed opds;
  final int index;
  final LibraryViewModel viewModel;

  const new({
    super.key,
    required this.opds,
    required this.index,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: .bottomCenter,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(
                  RouteNames.opds,
                  pathParameters: {'opdsId': opds.id},
                );
              },
              child: Card(margin: .all(0), child: SizedBox.expand()),
            ),
          ),
        ),
        Padding(
          padding: .only(
            top: viewModel.librarySpacing == .comfortable
                ? 8
                : viewModel.librarySpacing == .normal
                ? 6
                : 4,
          ),
          child: SizedBox(
            width: .infinity,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: .ellipsis,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    text: opds.feed!.title,
                  ),
                ),
                RichText(
                  maxLines: 1,
                  overflow: .ellipsis,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style
                        .apply(color: ColorScheme.of(context).outline),
                    text: opds.feed!.entries.isNotEmpty
                        ? opds.feed!.entries.length == 1
                              ? '${opds.feed!.entries.length} entry'
                              : '${opds.feed!.entries.length} entries'
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
