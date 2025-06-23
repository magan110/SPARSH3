import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';
import 'dsr_entry.dart';

class CheckSamplingAtSite extends StatefulWidget {
  const CheckSamplingAtSite({super.key});

  @override
  State<CheckSamplingAtSite> createState() => _CheckSamplingAtSiteState();
}

class _CheckSamplingAtSiteState extends State<CheckSamplingAtSite> {
  // ─── State & Controllers ────────────────────────────────────────────────────
  String? _processItem = 'Select';
  final _processItems = ['Select', 'Add', 'Update'];

  final _dateController = TextEditingController();
  final _reportDateController = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _selectedReportDate;

  final _siteController = TextEditingController();
  final _productController = TextEditingController();
  final _potentialController = TextEditingController();
  final _applicatorController = TextEditingController();

  String? _qualityItem = 'Select';
  final _qualityItems = ['Select', 'Average', 'Medium', 'Good'];

  String? _statusItem = 'Select';
  final _statusItems = [
    'Select',
    'Yet To be Checked By Purchaser',
    'Approved',
    'Rejected',
  ];

  final _contactNameController = TextEditingController();
  final _mobileController = TextEditingController();

  final List<XFile?> _selectedImages = [null];
  final _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _dateController.dispose();
    _reportDateController.dispose();
    _siteController.dispose();
    _productController.dispose();
    _potentialController.dispose();
    _applicatorController.dispose();
    _contactNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  Future<void> _pickDate(
    TextEditingController ctrl,
    DateTime? initialDate,
    ValueChanged<DateTime> onSelected,
  ) async {
    final now = DateTime.now();
    final pick = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );
    if (pick != null) {
      onSelected(pick);
      ctrl.text = DateFormat('yyyy-MM-dd').format(pick);
    }
  }

  Future<void> _pickImage(int idx) async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _selectedImages[idx] = file);
    }
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

  void _addImageField() {
    if (_selectedImages.length < 3) {
      setState(() => _selectedImages.add(null));
    }
  }

  void _removeImageField(int idx) {
    if (_selectedImages.length > 1) {
      setState(() => _selectedImages.removeAt(idx));
    }
  }

  void _onSubmit(bool exitAfter) {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          exitAfter
              ? 'Form validated. Exiting…'
              : 'Form validated. Ready for new entry.',
        ),
        backgroundColor: Colors.green,
      ),
    );
    if (exitAfter) {
      Navigator.of(context).pop();
    } else {
      _formKey.currentState!.reset();
      setState(() {
        _processItem = 'Select';
        _selectedDate = null;
        _selectedReportDate = null;
        _dateController.clear();
        _reportDateController.clear();
        _siteController.clear();
        _productController.clear();
        _potentialController.clear();
        _applicatorController.clear();
        _qualityItem = 'Select';
        _statusItem = 'Select';
        _contactNameController.clear();
        _mobileController.clear();
        _selectedImages
          ..clear()
          ..add(null);
      });
    }
  }
  // ─────────────────────────────────────────────────────────────────────────────

  // ─── Widget Builders ────────────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.015),
      child: Text(
        text,
        style: TextStyle(
          fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.03,
        ),
        isCollapsed: true,
      ),
      items:
          items
              .map(
                (it) => DropdownMenuItem(
                  value: it,
                  child: Text(
                    it,
                    style: TextStyle(
                      fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDateField(
    TextEditingController ctrl,
    VoidCallback onTap,
    String hint, {
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: ctrl,
    readOnly: true,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: onTap,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    onTap: onTap,
    validator: validator,
  );

  Widget _buildTextField(
    String hint,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: ctrl,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    validator: validator,
  );

  Widget _buildImageRow(int idx) {
    final file = _selectedImages[idx];
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document ${idx + 1}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
          ),
        ),
        SizedBox(height: screenWidth * 0.015),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(idx),
                icon: Icon(
                  file != null ? Icons.refresh : Icons.upload_file,
                  size: (screenWidth * 0.04).clamp(16.0, 20.0),
                ),
                label: Text(
                  file != null ? 'Replace' : 'Upload',
                  style: TextStyle(
                    fontSize: (screenWidth * 0.03).clamp(11.0, 14.0),
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            if (file != null)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showImage(file),
                  icon: Icon(
                    Icons.visibility,
                    size: (screenWidth * 0.04).clamp(16.0, 20.0),
                  ),
                  label: Text(
                    'View',
                    style: TextStyle(
                      fontSize: (screenWidth * 0.03).clamp(11.0, 14.0),
                    ),
                  ),
                ),
              ),
            if (_selectedImages.length > 1 && idx == _selectedImages.length - 1)
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                  size: (screenWidth * 0.05).clamp(18.0, 24.0),
                ),
                onPressed: () => _removeImageField(idx),
              ),
          ],
        ),
        SizedBox(height: screenWidth * 0.04),
      ],
    );
  }
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DsrEntry()),
              ),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          'Check Sampling at Site',
          style: TextStyle(
            fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Process
              _buildLabel('Process Type'),
              _buildDropdown(
                value: _processItem,
                items: _processItems,
                onChanged: (v) => setState(() => _processItem = v),
                validator:
                    (v) => (v == null || v == 'Select') ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),

              // Dates
              _buildLabel('Submission Date'),
              _buildDateField(
                _dateController,
                () => _pickDate(
                  _dateController,
                  _selectedDate,
                  (d) => _selectedDate = d,
                ),
                'Select Submission Date',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),
              _buildLabel('Report Date'),
              _buildDateField(
                _reportDateController,
                () => _pickDate(
                  _reportDateController,
                  _selectedReportDate,
                  (d) => _selectedReportDate = d,
                ),
                'Select Report Date',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),

              // Site & Product
              _buildLabel('Site Name'),
              _buildTextField(
                'Enter Site Name',
                _siteController,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),
              _buildLabel('Product Name'),
              _buildTextField(
                'Enter Product Name',
                _productController,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),

              // Potential & Applicator
              _buildLabel('Potential (MT)'),
              _buildTextField(
                'Enter Potential',
                _potentialController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  return null;
                },
              ),
              SizedBox(height: screenWidth * 0.04),
              _buildLabel('Applicator Name'),
              _buildTextField(
                'Enter Applicator Name',
                _applicatorController,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),

              // Quality & Status
              _buildLabel('Quality of Sample'),
              _buildDropdown(
                value: _qualityItem,
                items: _qualityItems,
                onChanged: (v) => setState(() => _qualityItem = v),
                validator:
                    (v) => (v == null || v == 'Select') ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),
              _buildLabel('Status of Sample'),
              _buildDropdown(
                value: _statusItem,
                items: _statusItems,
                onChanged: (v) => setState(() => _statusItem = v),
                validator:
                    (v) => (v == null || v == 'Select') ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),

              // Contact & Mobile
              _buildLabel('Contact Name'),
              _buildTextField(
                'Enter Contact Name',
                _contactNameController,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.04),
              _buildLabel('Mobile Number'),
              _buildTextField(
                'Enter Mobile Number',
                _mobileController,
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: screenWidth * 0.06),

              // Supporting Documents
              _buildLabel('Upload Images'),
              SizedBox(height: screenWidth * 0.03),
              ...List.generate(_selectedImages.length, _buildImageRow),
              if (_selectedImages.length < 3)
                Center(
                  child: TextButton.icon(
                    onPressed: _addImageField,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add More Image'),
                  ),
                ),
              SizedBox(height: screenWidth * 0.06),

              // Submit Buttons
              ElevatedButton(
                onPressed: () => _onSubmit(false),
                child: const Text('Submit & New'),
              ),
              SizedBox(height: screenWidth * 0.03),
              ElevatedButton(
                onPressed: () => _onSubmit(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                ),
                child: const Text('Submit & Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
