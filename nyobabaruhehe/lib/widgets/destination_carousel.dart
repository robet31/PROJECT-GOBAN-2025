import 'package:flutter/material.dart';
import '../models/destination.dart';

class DestinationCarousel extends StatelessWidget {
  final List<Destination> destinations;
  final Function(int) onDestinationSelected;
  final ValueChanged<Destination> onDestinationTapped;
  final PageController pageController;

  const DestinationCarousel({
    super.key,
    required this.destinations,
    required this.onDestinationSelected,
    required this.onDestinationTapped,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: destinations.length,
              onPageChanged: onDestinationSelected,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return GestureDetector(
                  onTap: () => onDestinationTapped(destination),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 8,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: destination.imageUrls.isNotEmpty
                              ? Image.network(
                                  destination.imageUrls[0],
                                  width: 140,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      width: 140,
                                      height: double.infinity,
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                )
                              : Container(
                                  width: 140,
                                  height: double.infinity,
                                  color: Colors.grey,
                                  child: const Icon(Icons.image),
                                ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    destination.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    destination.description,
                                    style: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search destination...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}