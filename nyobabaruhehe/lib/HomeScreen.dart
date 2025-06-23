// import 'package:flutter/material.dart';
// import 'camp_detail_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 // Header
//                 const Text(
//                   "Hello, Orely",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF141E46),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
                
//                 // Search Bar
//                 Container(
//                   height: 50,
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: const Color(0xFF8DECB4)),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.search, color: Color(0xFF41B06E)),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: "Search camp",
//                             border: InputBorder.none,
//                             hintStyle: TextStyle(
//                               color: Colors.grey.shade400,
//                             ),
//                           ),
//                           style: const TextStyle(
//                             color: Color(0xFF141E46),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
                
//                 // Nearby Camp Section
//                 const Text(
//                   "Nearby camp",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF141E46),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 const Text(
//                   "Turn on your location service",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF141E46),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF41B06E),
//                     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   icon: const Icon(Icons.location_on, color: Colors.white),
//                   label: const Text(
//                     "Turn on location",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
                
//                 // City Tags
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       _buildCityTag("Los Angeles"),
//                       const SizedBox(width: 10),
//                       _buildCityTag("Chicago"),
//                       const SizedBox(width: 10),
//                       _buildCityTag("Houston"),
//                       const SizedBox(width: 10),
//                       _buildCityTag("San Diego"),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
                
//                 // Recommendation Title
//                 const Text(
//                   "Recommendation",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF141E46),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
                
//                 // Camp Cards
//                 _buildCampCard(
//                   context,
//                   "Camp Big Sky Adventure",
//                   "Tekovazione National Park, Wyoming",
//                   "June",
//                   "28",
//                 ),
//                 const SizedBox(height: 20),
//                 _buildCampCard(
//                   context,
//                   "Mountain Explorer Camp",
//                   "Rocky Mountains, Colorado",
//                   "July",
//                   "15",
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCityTag(String city) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: const Color(0xFF8DECB4)),
//       ),
//       child: Text(
//         city,
//         style: const TextStyle(
//           color: Color(0xFF141E46),
//         ),
//       ),
//     );
//   }

//   Widget _buildCampCard(
//     BuildContext context,
//     String title,
//     String location,
//     String month,
//     String spots,
//   ) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const CampDetailScreen()),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Placeholder
//             Container(
//               height: 180,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF8DECB4).withOpacity(0.5),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                 ),
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.image,
//                   size: 50,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//             ),
            
//             // Content
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 18,
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
//                         child: Text(
//                           spots,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF141E46),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
                  
//                   // Location
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, size: 16, color: Color(0xFF41B06E)),
//                       const SizedBox(width: 5),
//                       Text(
//                         location,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF141E46),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
                  
//                   // Month
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_today, size: 16, color: Color(0xFF41B06E)),
//                       const SizedBox(width: 5),
//                       Text(
//                         month,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF141E46),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
                  
//                   // Description
//                   const Text(
//                     "Explore Yellowstone and beyond! Get your feet wet and your hands dirty, while you explore and read more...",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF141E46),
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }