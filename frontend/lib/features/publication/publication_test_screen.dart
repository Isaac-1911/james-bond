// import 'package:flutter/material.dart';
// import 'package:frontend/core/services/api_service.dart';

// class PublicationTestScreen extends StatefulWidget {
//   const PublicationTestScreen({super.key});

//   @override
//   State<PublicationTestScreen> createState() => _PublicationTestScreen();
// }

// class _PublicationTestScreen extends State<PublicationTestScreen> {
//   String result = 'Tekan tombol untuk GET /api/publication';

//   Future<void> fetchPublication() async {
//     try {
//       final api = ApiService();
//       final res = await api.getPublication();

//       setState(() {
//         result = res.toString();
//       });
//     } catch (e) {
//       setState(() {
//         result = 'ERROR: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('GET Publication Test'), centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsetsGeometry.all(16),
//         child: Column(
//           children: [
//             ElevatedButton(onPressed: fetchPublication, child: Text('GET Publication')),
//             SizedBox(height: 16),
//             Expanded(child: SingleChildScrollView(child: Text(result))),
//           ],
//         ),
//       ),
//     );
//   }
// }
