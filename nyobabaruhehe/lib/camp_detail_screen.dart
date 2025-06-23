// import 'package:flutter/material.dart';

// class CampDetailScreen extends StatelessWidget {
//   const CampDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF41B06E),
//         title: const Text(
//           "Camp Details",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Placeholder
//             Container(
//               height: 250,
//               color: const Color(0xFF8DECB4).withOpacity(0.5),
//               child: Center(
//                 child: Icon(
//                   Icons.image,
//                   size: 70,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//             ),
            
//             // Title Section
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Expanded(
//                         child: Text(
//                           "Camp Big Sky Adventure",
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF141E46),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF8DECB4),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Text(
//                           "28",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF141E46),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
                  
//                   // Location & Date
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, size: 16, color: Color(0xFF41B06E)),
//                       const SizedBox(width: 5),
//                       const Expanded(
//                         child: Text(
//                           "Tekovazione National Park, Wyoming",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Color(0xFF141E46),
//                           ),
//                         ),
//                       ),
//                       const Icon(Icons.calendar_today, size: 16, color: Color(0xFF41B06E)),
//                       const SizedBox(width: 5),
//                       const Text(
//                         "June",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF141E46),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
            
//             // Description Section
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Description",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF141E46),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Explore Yellowstone and beyond! Get your feet wet and your hands dirty, while you explore and learn about the natural wonders of the national park.",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF141E46),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Camp Details
//             const Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Camp Details",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF141E46),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   _DetailRow(title: "Duration", value: "3 Months"),
//                   _DetailRow(title: "Time", value: "April 09:00"),
//                   _DetailRow(title: "Age", value: "9-12 years old"),
//                   _DetailRow(title: "Day", value: "Tuesday | Outside"),
//                   _DetailRow(title: "Lunch Provided", value: "Yes"),
//                   _DetailRow(title: "Location", value: "Outside"),
//                 ],
//               ),
//             ),
            
//             // Reservation Button
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF41B06E),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   "Reservation",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _DetailRow extends StatelessWidget {
//   final String title;
//   final String value;
  
//   const _DetailRow({required this.title, required this.value});
  
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Color(0xFF141E46),
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF141E46),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }