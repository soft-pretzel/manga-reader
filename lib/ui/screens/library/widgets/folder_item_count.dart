// import 'package:flutter/material.dart';

// import '../library_view_model.dart';
// import '../../../../data/models/folder.dart';

// class FolderItemCount extends StatefulWidget {
//   const FolderItemCount({
//     super.key,
//     required this.series,
//     required this.viewModel,
//   });

//   final Folder series;
//   final LibraryViewModel viewModel;

//   @override
//   State<FolderItemCount> createState() => _FolderItemCountState();
// }

// class _FolderItemCountState extends State<FolderItemCount> {
//   @override
//   void initState() {
//     super.initState();
//     if (widget.series.itemCount == null) {
//       widget.viewModel.getFolderItemCount.execute(widget.series);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: widget.viewModel.getFolderItemCount,
//       builder: (context, child) {
//         if (widget.viewModel.getFolderItemCount.running) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (widget.viewModel.getFolderItemCount.error) {
//           return Center(
//             child: Icon(
//               Icons.error_outline,
//               color: Theme.of(context).colorScheme.error,
//             ),
//           );
//         }

//         return Positioned(
//           left: 0,
//           right: 0,
//           bottom: 0,
//           child: Container(
//             padding: EdgeInsets.fromLTRB(8, 64, 0, 4),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: AlignmentGeometry.bottomCenter,
//                 end: AlignmentGeometry.topCenter,
//                 colors: [
//                   Theme.of(context).colorScheme.surface.withAlpha(224),
//                   Theme.of(context).colorScheme.surface.withAlpha(0),
//                 ],
//               ),
//             ),
//             child: Wrap(
//               children: [
//                 RichText(
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   text: TextSpan(
//                     text: (widget.series.itemCount == 1)
//                         ? '${widget.series.itemCount} item'
//                         : '${widget.series.itemCount} items',
//                     style: DefaultTextStyle.of(
//                       context,
//                     ).style.apply(color: Theme.of(context).colorScheme.primary),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
