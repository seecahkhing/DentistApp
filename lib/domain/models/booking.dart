enum BookingStatus { scheduled, confirmed, completed, cancelled }

extension BookingStatusX on BookingStatus {
  String get label => switch (this) {
    BookingStatus.scheduled => 'Scheduled',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.completed => 'Completed',
    BookingStatus.cancelled => 'Cancelled',
  };
}

class Booking {
  const Booking({
    required this.id,
    required this.fullName,
    required this.address,
    required this.mobileNumber,
    required this.hasInsurance,
    this.insuranceName,
    required this.scheduledAt,
    this.price,
    required this.status,
    this.reminderAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String fullName;
  final String address;
  final String mobileNumber;
  final bool hasInsurance;
  final String? insuranceName;
  final DateTime scheduledAt;
  final double? price;
  final BookingStatus status;
  final DateTime? reminderAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking copyWith({
    int? id,
    String? fullName,
    String? address,
    String? mobileNumber,
    bool? hasInsurance,
    String? insuranceName,
    bool clearInsuranceName = false,
    DateTime? scheduledAt,
    double? price,
    bool clearPrice = false,
    BookingStatus? status,
    DateTime? reminderAt,
    bool clearReminder = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      insuranceName: clearInsuranceName
          ? null
          : insuranceName ?? this.insuranceName,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      price: clearPrice ? null : price ?? this.price,
      status: status ?? this.status,
      reminderAt: clearReminder ? null : reminderAt ?? this.reminderAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BookingDraft {
  const BookingDraft({
    required this.fullName,
    required this.address,
    required this.mobileNumber,
    required this.hasInsurance,
    this.insuranceName,
    required this.scheduledAt,
    this.price,
    this.status = BookingStatus.scheduled,
    this.reminderAt,
  });

  final String fullName;
  final String address;
  final String mobileNumber;
  final bool hasInsurance;
  final String? insuranceName;
  final DateTime scheduledAt;
  final double? price;
  final BookingStatus status;
  final DateTime? reminderAt;
}
