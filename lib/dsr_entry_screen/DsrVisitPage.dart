import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'dsr_entry.dart';

class DsrVisitPage extends StatefulWidget {
  const DsrVisitPage({super.key});

  @override
  State<DsrVisitPage> createState() => _DsrVisitPageState();
}

class _DsrVisitPageState extends State<DsrVisitPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _visitPurposeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _visitType = 'Select';
  final List<String> _visitTypes = [
    'Select',
    'Customer Visit',
    'Site Visit',
    'Supplier Visit',
    'Market Survey',
    'Follow-up Visit',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final List<XFile?> _selectedImages = [null];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _visitPurposeController.dispose();
    _customerNameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visit details saved successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildImageRow(int idx) {
    final file = _selectedImages[idx];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Document ${idx + 1}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              icon: Icon(file != null ? Icons.refresh : Icons.upload_file),
              label: Text(file != null ? 'Replace' : 'Upload'),
              onPressed: () async {
                final img = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (img != null) setState(() => _selectedImages[idx] = img);
              },
            ),
            const SizedBox(width: 12),
            if (file != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.visibility),
                label: const Text('View'),
                onPressed: () => _showImage(file),
              ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _showImage(XFile file) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            child: Image.file(
              File(file.path),
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DsrEntry()),
              ),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          'DSR Visit Page',
          style: TextStyle(
            fontSize: (MediaQuery.of(context).size.width * 0.045).clamp(
              16.0,
              20.0,
            ),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Visit Details',
                        style: TextStyle(
                          fontSize: (MediaQuery.of(context).size.width * 0.045)
                              .clamp(16.0, 20.0),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          suffixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        onTap: _pickDate,
                        validator:
                            (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _visitType,
                        decoration: const InputDecoration(
                          labelText: 'Visit Type',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _visitTypes
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _visitType = v),
                        validator:
                            (v) =>
                                (v == null || v == 'Select')
                                    ? 'Required'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _visitPurposeController,
                        decoration: const InputDecoration(
                          labelText: 'Visit Purpose',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _customerNameController,
                        decoration: const InputDecoration(
                          labelText: 'Customer/Contact Name',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notes/Comments',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Attachments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(_selectedImages.length, _buildImageRow),
                      if (_selectedImages.length < 5)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add More Images'),
                          onPressed:
                              () => setState(() => _selectedImages.add(null)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Submit Visit Details',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
