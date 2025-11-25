import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/company_portal/presentation/blocs/bloc/company_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CompanyQrScannerPage extends StatefulWidget {
  const CompanyQrScannerPage({super.key});

  @override
  State<CompanyQrScannerPage> createState() => _CompanyQrScannerPageState();
}

class _CompanyQrScannerPageState extends State<CompanyQrScannerPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Candidate QR')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: (ctrl) {
          controller = ctrl;
          ctrl.scannedDataStream.listen((scan) async {
            final code = scan.code;
            if (code == null) return;
            ctrl.pauseCamera();
            context.read<CompanyBloc>().add(AddCandidateBookmarkEvent(code));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Candidate bookmarked!')),
            );
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) Navigator.pop(context);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
