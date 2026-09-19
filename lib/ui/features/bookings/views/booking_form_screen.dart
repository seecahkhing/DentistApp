import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/booking.dart';
import '../../../core/app_theme.dart';
import '../view_models/bookings_view_model.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key, this.booking});

  final Booking? booking;

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _mobile;
  late final TextEditingController _insuranceName;
  late final TextEditingController _price;

  late DateTime _scheduledAt;
  DateTime? _reminderAt;
  late bool _hasInsurance;
  late BookingStatus _status;
  bool _saving = false;

  bool get _isEdit => widget.booking != null;

  @override
  void initState() {
    super.initState();
    final booking = widget.booking;
    _name = TextEditingController(text: booking?.fullName ?? '');
    _address = TextEditingController(text: booking?.address ?? '');
    _mobile = TextEditingController(text: booking?.mobileNumber ?? '');
    _insuranceName = TextEditingController(text: booking?.insuranceName ?? '');
    _price = TextEditingController(
      text: booking?.price == null ? '' : booking!.price!.toStringAsFixed(2),
    );
    _scheduledAt = booking?.scheduledAt ?? DateTime.now();
    _reminderAt = booking?.reminderAt;
    _hasInsurance = booking?.hasInsurance ?? false;
    _status = booking?.status ?? BookingStatus.scheduled;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _mobile.dispose();
    _insuranceName.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool reminder}) async {
    final current = reminder ? (_reminderAt ?? _scheduledAt) : _scheduledAt;
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (!mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (!mounted || time == null) return;
    final value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (reminder) {
        _reminderAt = value;
      } else {
        _scheduledAt = value;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final priceText = _price.text.trim();
    final draft = BookingDraft(
      fullName: _name.text.trim(),
      address: _address.text.trim(),
      mobileNumber: _mobile.text.trim(),
      hasInsurance: _hasInsurance,
      insuranceName: _hasInsurance ? _insuranceName.text.trim() : null,
      scheduledAt: _scheduledAt,
      price: priceText.isEmpty ? null : double.tryParse(priceText),
      status: _status,
      reminderAt: _reminderAt,
    );
    final vm = context.read<BookingsViewModel>();
    try {
      if (_isEdit) {
        await vm.update(widget.booking!.id, draft);
      } else {
        await vm.create(draft);
      }
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit booking' : 'New booking'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          children: [
            TextFormField(
              key: const Key('fullName'),
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: requiredField,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('address'),
              controller: _address,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: requiredField,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('mobile'),
              controller: _mobile,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Mobile number'),
              validator: requiredField,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Appointment'),
              subtitle: Text(formatDateTime(_scheduledAt)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () => _pickDateTime(reminder: false),
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('price'),
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Price / cost',
                hintText: 'Optional',
              ),
              validator: validatePrice,
            ),
            const SizedBox(height: 16),
            const Text(
              'Insurance',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('No')),
                ButtonSegment(value: true, label: Text('Yes')),
              ],
              selected: {_hasInsurance},
              onSelectionChanged: (value) {
                setState(() => _hasInsurance = value.first);
              },
            ),
            if (_hasInsurance) ...[
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('insuranceName'),
                controller: _insuranceName,
                decoration: const InputDecoration(
                  labelText: 'Name of insurance',
                ),
                validator: (value) =>
                    validateInsuranceName(value, hasInsurance: _hasInsurance),
              ),
            ],
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reminder'),
              subtitle: Text(
                _reminderAt == null ? 'None' : formatDateTime(_reminderAt!),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_reminderAt != null)
                    IconButton(
                      tooltip: 'Clear reminder',
                      onPressed: () => setState(() => _reminderAt = null),
                      icon: const Icon(Icons.close),
                    ),
                  const Icon(Icons.alarm_outlined),
                ],
              ),
              onTap: () => _pickDateTime(reminder: true),
            ),
            if (_isEdit) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<BookingStatus>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  for (final status in BookingStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String? requiredField(String? value) {
  if (value == null || value.trim().isEmpty) return 'Required';
  return null;
}

String? validateInsuranceName(String? value, {required bool hasInsurance}) {
  if (!hasInsurance) return null;
  return requiredField(value);
}

String? validatePrice(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final parsed = double.tryParse(value.trim());
  if (parsed == null) return 'Enter a valid amount';
  if (parsed < 0) return 'Must be positive';
  return null;
}
