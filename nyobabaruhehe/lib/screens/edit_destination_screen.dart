// lib/screens/edit_destination_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../models/destination.dart';
import '../services/destination_service.dart';
import '../widgets/location_picker.dart';

class EditDestinationScreen extends StatefulWidget {
  final Destination? destination;

  const EditDestinationScreen({super.key, this.destination});

  @override
  _EditDestinationScreenState createState() => _EditDestinationScreenState();
}

class _EditDestinationScreenState extends State<EditDestinationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _ratingController = TextEditingController();
  List<File> _images = []; // Ubah menjadi List
  List<String> _imageUrls = []; // Ubah menjadi List
  LatLng? _location;
  bool _isLoading = false;

  final DestinationService _service = DestinationService();

  @override
  void initState() {
    super.initState();
    if (widget.destination != null) {
      _nameController.text = widget.destination!.name;
      _descriptionController.text = widget.destination!.description;
      _priceController.text = widget.destination!.price ?? '';
      _ratingController.text = widget.destination!.rating?.toString() ?? '';
      _location = widget.destination!.location;
      _imageUrls = widget.destination!.imageUrls; // Inisialisasi _imageUrls
      if (widget.destination != null) {
        _imageUrls = widget.destination!.imageUrls;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.destination == null ? 'Add Destination' : 'Edit Destination',
        ),
        actions: [
          if (widget.destination != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteDestination,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Image Picker
                    _buildImagePicker(),
                    const SizedBox(height: 20),

                    // Form Fields
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Destination Name',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Name is required' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      validator: (value) =>
                          value!.isEmpty ? 'Description is required' : null,
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price (optional)',
                      ),
                    ),
                    TextFormField(
                      controller: _ratingController,
                      decoration: const InputDecoration(
                        labelText: 'Rating (optional)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    // Location Picker
                    LocationPicker(
                      initialLocation: _location,
                      onLocationSelected: (location) => _location = location,
                    ),
                    const SizedBox(height: 20),

                    // Save Button
                    ElevatedButton(
                      onPressed: _saveDestination,
                      child: const Text('Save Destination'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Images:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Tampilkan gambar yang sudah ada
            ..._imageUrls.map((url) => _buildNetworkImagePreview(url)).toList(),
            // Tampilkan gambar baru yang dipilih
            ..._images.map((image) => _buildFileImagePreview(image)).toList(),
            _buildAddImageButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildFileImagePreview(File image) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.red),
            onPressed: () {
              setState(() {
                _images.remove(image);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkImagePreview(String url) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.red),
            onPressed: () {
              setState(() {
                _imageUrls.remove(url);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(dynamic _image, dynamic _imageUrl) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: _image != null
                  ? FileImage(_image!) as ImageProvider
                  : NetworkImage(_imageUrl!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => setState(() {
              _image = null;
              _imageUrl = null;
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add_a_photo, size: 30),
      ),
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _saveDestination() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty && _imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }
    if (_location == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a location')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload gambar baru
      final newImageUrls = await _service.uploadImages(_images);
      // Gabungkan URL baru dengan URL yang sudah ada
      final allImageUrls = [..._imageUrls, ...newImageUrls];

      final destination = Destination(
        id: widget.destination?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrls: allImageUrls,
        location: _location!,
        price: _priceController.text.isEmpty ? null : _priceController.text,
        rating: _ratingController.text.isEmpty
            ? null
            : double.tryParse(_ratingController.text),
      );

      if (widget.destination == null) {
        await _service.addDestination(destination);
      } else {
        await _service.updateDestination(destination);
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDestination() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
          'Are you sure you want to delete this destination?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await _service.deleteDestination(widget.destination!.id!);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
