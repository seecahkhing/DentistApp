// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BookingsTable extends Bookings
    with TableInfo<$BookingsTable, BookingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mobileNumberMeta = const VerificationMeta(
    'mobileNumber',
  );
  @override
  late final GeneratedColumn<String> mobileNumber = GeneratedColumn<String>(
    'mobile_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasInsuranceMeta = const VerificationMeta(
    'hasInsurance',
  );
  @override
  late final GeneratedColumn<bool> hasInsurance = GeneratedColumn<bool>(
    'has_insurance',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_insurance" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _insuranceNameMeta = const VerificationMeta(
    'insuranceName',
  );
  @override
  late final GeneratedColumn<String> insuranceName = GeneratedColumn<String>(
    'insurance_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BookingStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BookingStatus>($BookingsTable.$converterstatus);
  static const VerificationMeta _reminderAtMeta = const VerificationMeta(
    'reminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    address,
    mobileNumber,
    hasInsurance,
    insuranceName,
    scheduledAt,
    price,
    status,
    reminderAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookings';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('mobile_number')) {
      context.handle(
        _mobileNumberMeta,
        mobileNumber.isAcceptableOrUnknown(
          data['mobile_number']!,
          _mobileNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mobileNumberMeta);
    }
    if (data.containsKey('has_insurance')) {
      context.handle(
        _hasInsuranceMeta,
        hasInsurance.isAcceptableOrUnknown(
          data['has_insurance']!,
          _hasInsuranceMeta,
        ),
      );
    }
    if (data.containsKey('insurance_name')) {
      context.handle(
        _insuranceNameMeta,
        insuranceName.isAcceptableOrUnknown(
          data['insurance_name']!,
          _insuranceNameMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
        _reminderAtMeta,
        reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      mobileNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile_number'],
      )!,
      hasInsurance: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_insurance'],
      )!,
      insuranceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insurance_name'],
      ),
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      status: $BookingsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      reminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BookingsTable createAlias(String alias) {
    return $BookingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BookingStatus, String, String> $converterstatus =
      const EnumNameConverter<BookingStatus>(BookingStatus.values);
}

class BookingRow extends DataClass implements Insertable<BookingRow> {
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
  const BookingRow({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['full_name'] = Variable<String>(fullName);
    map['address'] = Variable<String>(address);
    map['mobile_number'] = Variable<String>(mobileNumber);
    map['has_insurance'] = Variable<bool>(hasInsurance);
    if (!nullToAbsent || insuranceName != null) {
      map['insurance_name'] = Variable<String>(insuranceName);
    }
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    {
      map['status'] = Variable<String>(
        $BookingsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BookingsCompanion toCompanion(bool nullToAbsent) {
    return BookingsCompanion(
      id: Value(id),
      fullName: Value(fullName),
      address: Value(address),
      mobileNumber: Value(mobileNumber),
      hasInsurance: Value(hasInsurance),
      insuranceName: insuranceName == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceName),
      scheduledAt: Value(scheduledAt),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      status: Value(status),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BookingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookingRow(
      id: serializer.fromJson<int>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      address: serializer.fromJson<String>(json['address']),
      mobileNumber: serializer.fromJson<String>(json['mobileNumber']),
      hasInsurance: serializer.fromJson<bool>(json['hasInsurance']),
      insuranceName: serializer.fromJson<String?>(json['insuranceName']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      price: serializer.fromJson<double?>(json['price']),
      status: $BookingsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fullName': serializer.toJson<String>(fullName),
      'address': serializer.toJson<String>(address),
      'mobileNumber': serializer.toJson<String>(mobileNumber),
      'hasInsurance': serializer.toJson<bool>(hasInsurance),
      'insuranceName': serializer.toJson<String?>(insuranceName),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'price': serializer.toJson<double?>(price),
      'status': serializer.toJson<String>(
        $BookingsTable.$converterstatus.toJson(status),
      ),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BookingRow copyWith({
    int? id,
    String? fullName,
    String? address,
    String? mobileNumber,
    bool? hasInsurance,
    Value<String?> insuranceName = const Value.absent(),
    DateTime? scheduledAt,
    Value<double?> price = const Value.absent(),
    BookingStatus? status,
    Value<DateTime?> reminderAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BookingRow(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    address: address ?? this.address,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    hasInsurance: hasInsurance ?? this.hasInsurance,
    insuranceName: insuranceName.present
        ? insuranceName.value
        : this.insuranceName,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    price: price.present ? price.value : this.price,
    status: status ?? this.status,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BookingRow copyWithCompanion(BookingsCompanion data) {
    return BookingRow(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      address: data.address.present ? data.address.value : this.address,
      mobileNumber: data.mobileNumber.present
          ? data.mobileNumber.value
          : this.mobileNumber,
      hasInsurance: data.hasInsurance.present
          ? data.hasInsurance.value
          : this.hasInsurance,
      insuranceName: data.insuranceName.present
          ? data.insuranceName.value
          : this.insuranceName,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      price: data.price.present ? data.price.value : this.price,
      status: data.status.present ? data.status.value : this.status,
      reminderAt: data.reminderAt.present
          ? data.reminderAt.value
          : this.reminderAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookingRow(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('address: $address, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('hasInsurance: $hasInsurance, ')
          ..write('insuranceName: $insuranceName, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('price: $price, ')
          ..write('status: $status, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    address,
    mobileNumber,
    hasInsurance,
    insuranceName,
    scheduledAt,
    price,
    status,
    reminderAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookingRow &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.address == this.address &&
          other.mobileNumber == this.mobileNumber &&
          other.hasInsurance == this.hasInsurance &&
          other.insuranceName == this.insuranceName &&
          other.scheduledAt == this.scheduledAt &&
          other.price == this.price &&
          other.status == this.status &&
          other.reminderAt == this.reminderAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BookingsCompanion extends UpdateCompanion<BookingRow> {
  final Value<int> id;
  final Value<String> fullName;
  final Value<String> address;
  final Value<String> mobileNumber;
  final Value<bool> hasInsurance;
  final Value<String?> insuranceName;
  final Value<DateTime> scheduledAt;
  final Value<double?> price;
  final Value<BookingStatus> status;
  final Value<DateTime?> reminderAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BookingsCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.address = const Value.absent(),
    this.mobileNumber = const Value.absent(),
    this.hasInsurance = const Value.absent(),
    this.insuranceName = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.price = const Value.absent(),
    this.status = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BookingsCompanion.insert({
    this.id = const Value.absent(),
    required String fullName,
    required String address,
    required String mobileNumber,
    this.hasInsurance = const Value.absent(),
    this.insuranceName = const Value.absent(),
    required DateTime scheduledAt,
    this.price = const Value.absent(),
    required BookingStatus status,
    this.reminderAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : fullName = Value(fullName),
       address = Value(address),
       mobileNumber = Value(mobileNumber),
       scheduledAt = Value(scheduledAt),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BookingRow> custom({
    Expression<int>? id,
    Expression<String>? fullName,
    Expression<String>? address,
    Expression<String>? mobileNumber,
    Expression<bool>? hasInsurance,
    Expression<String>? insuranceName,
    Expression<DateTime>? scheduledAt,
    Expression<double>? price,
    Expression<String>? status,
    Expression<DateTime>? reminderAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (address != null) 'address': address,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (hasInsurance != null) 'has_insurance': hasInsurance,
      if (insuranceName != null) 'insurance_name': insuranceName,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (price != null) 'price': price,
      if (status != null) 'status': status,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BookingsCompanion copyWith({
    Value<int>? id,
    Value<String>? fullName,
    Value<String>? address,
    Value<String>? mobileNumber,
    Value<bool>? hasInsurance,
    Value<String?>? insuranceName,
    Value<DateTime>? scheduledAt,
    Value<double?>? price,
    Value<BookingStatus>? status,
    Value<DateTime?>? reminderAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BookingsCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      insuranceName: insuranceName ?? this.insuranceName,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      price: price ?? this.price,
      status: status ?? this.status,
      reminderAt: reminderAt ?? this.reminderAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (mobileNumber.present) {
      map['mobile_number'] = Variable<String>(mobileNumber.value);
    }
    if (hasInsurance.present) {
      map['has_insurance'] = Variable<bool>(hasInsurance.value);
    }
    if (insuranceName.present) {
      map['insurance_name'] = Variable<String>(insuranceName.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $BookingsTable.$converterstatus.toSql(status.value),
      );
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookingsCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('address: $address, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('hasInsurance: $hasInsurance, ')
          ..write('insuranceName: $insuranceName, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('price: $price, ')
          ..write('status: $status, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookingsTable bookings = $BookingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [bookings];
}

typedef $$BookingsTableCreateCompanionBuilder =
    BookingsCompanion Function({
      Value<int> id,
      required String fullName,
      required String address,
      required String mobileNumber,
      Value<bool> hasInsurance,
      Value<String?> insuranceName,
      required DateTime scheduledAt,
      Value<double?> price,
      required BookingStatus status,
      Value<DateTime?> reminderAt,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$BookingsTableUpdateCompanionBuilder =
    BookingsCompanion Function({
      Value<int> id,
      Value<String> fullName,
      Value<String> address,
      Value<String> mobileNumber,
      Value<bool> hasInsurance,
      Value<String?> insuranceName,
      Value<DateTime> scheduledAt,
      Value<double?> price,
      Value<BookingStatus> status,
      Value<DateTime?> reminderAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$BookingsTableFilterComposer
    extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasInsurance => $composableBuilder(
    column: $table.hasInsurance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insuranceName => $composableBuilder(
    column: $table.insuranceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BookingStatus, BookingStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasInsurance => $composableBuilder(
    column: $table.hasInsurance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insuranceName => $composableBuilder(
    column: $table.insuranceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasInsurance => $composableBuilder(
    column: $table.hasInsurance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get insuranceName => $composableBuilder(
    column: $table.insuranceName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BookingStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BookingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookingsTable,
          BookingRow,
          $$BookingsTableFilterComposer,
          $$BookingsTableOrderingComposer,
          $$BookingsTableAnnotationComposer,
          $$BookingsTableCreateCompanionBuilder,
          $$BookingsTableUpdateCompanionBuilder,
          (
            BookingRow,
            BaseReferences<_$AppDatabase, $BookingsTable, BookingRow>,
          ),
          BookingRow,
          PrefetchHooks Function()
        > {
  $$BookingsTableTableManager(_$AppDatabase db, $BookingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> mobileNumber = const Value.absent(),
                Value<bool> hasInsurance = const Value.absent(),
                Value<String?> insuranceName = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<BookingStatus> status = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BookingsCompanion(
                id: id,
                fullName: fullName,
                address: address,
                mobileNumber: mobileNumber,
                hasInsurance: hasInsurance,
                insuranceName: insuranceName,
                scheduledAt: scheduledAt,
                price: price,
                status: status,
                reminderAt: reminderAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fullName,
                required String address,
                required String mobileNumber,
                Value<bool> hasInsurance = const Value.absent(),
                Value<String?> insuranceName = const Value.absent(),
                required DateTime scheduledAt,
                Value<double?> price = const Value.absent(),
                required BookingStatus status,
                Value<DateTime?> reminderAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => BookingsCompanion.insert(
                id: id,
                fullName: fullName,
                address: address,
                mobileNumber: mobileNumber,
                hasInsurance: hasInsurance,
                insuranceName: insuranceName,
                scheduledAt: scheduledAt,
                price: price,
                status: status,
                reminderAt: reminderAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookingsTable,
      BookingRow,
      $$BookingsTableFilterComposer,
      $$BookingsTableOrderingComposer,
      $$BookingsTableAnnotationComposer,
      $$BookingsTableCreateCompanionBuilder,
      $$BookingsTableUpdateCompanionBuilder,
      (BookingRow, BaseReferences<_$AppDatabase, $BookingsTable, BookingRow>),
      BookingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookingsTableTableManager get bookings =>
      $$BookingsTableTableManager(_db, _db.bookings);
}
