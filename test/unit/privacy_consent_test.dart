import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavan360/core/services/storage_service.dart';
import 'package:uzhavan360/state/job_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    await StorageService.setUserId('worker-velu-1');
  });

  group('Worker Privacy & Contact Sharing Consent Tests (Requirement 27)', () {
    test('Job application with explicit consent shares phone number', () async {
      final jobProvider = JobProvider();
      const testJobId = 'job-101';
      const workerPhone = '+919842112345';

      final success = await jobProvider.applyForJob(
        jobId: testJobId,
        shareContactConsent: true,
        contactPhone: workerPhone,
      );

      expect(success, isTrue);
      final app = jobProvider.myApplications.firstWhere((a) => a.jobId == testJobId);
      expect(app.shareContactConsent, isTrue);
      expect(app.contactPhone, equals(workerPhone));
    });

    test('Job application without consent conceals worker phone number', () async {
      final jobProvider = JobProvider();
      const testJobId = 'job-102';
      const workerPhone = '+919842112345';

      final success = await jobProvider.applyForJob(
        jobId: testJobId,
        shareContactConsent: false,
        contactPhone: workerPhone,
      );

      expect(success, isTrue);
      final app = jobProvider.myApplications.firstWhere((a) => a.jobId == testJobId);
      expect(app.shareContactConsent, isFalse);
      expect(app.contactPhone, isNull);
    });
  });
}
