import 'dart:io';

import 'package:equatable/equatable.dart';
class Certification extends Equatable {
  final String id;
  final String name;
  final String issuingInstitution;
  final DateTime issueDate;
  final DateTime? expirationDate;
  final File? credentialFile; // Not serialized to JSON/Map
  final String? credentialUrl;

  const Certification({
    required this.id,
    required this.name,
    required this.issuingInstitution,
    required this.issueDate,
    this.expirationDate,
    this.credentialFile,
    this.credentialUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'issuingInstitution': issuingInstitution,
      'issueDate': issueDate.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
      'credentialUrl': credentialUrl,
    };
  }

  factory Certification.fromMap(Map<String, dynamic> map) {
    return Certification(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      issuingInstitution: map['issuingInstitution'] ?? '',
      issueDate: DateTime.tryParse(map['issueDate'] ?? '') ?? DateTime.now(),
      expirationDate: map['expirationDate'] != null
          ? DateTime.tryParse(map['expirationDate'])
          : null,
      credentialUrl: map['credentialUrl'],
      credentialFile: null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    issuingInstitution,
    issueDate,
    expirationDate,
    credentialFile,
    credentialUrl,
  ];
}
