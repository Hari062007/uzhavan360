import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/storage_service.dart';
import '../models/job_model.dart';
import '../models/job_application_model.dart';

class JobRepository {
  final List<JobModel> _sampleJobs = [
    JobModel(
      id: 'job-101',
      employerId: 'owner-vadipatti',
      titleTa: 'நெல் அறுவடை மற்றும் கட்டு கட்டும் பணி',
      titleEn: 'Paddy Harvesting & Bundling Work',
      workType: 'harvesting',
      district: 'Madurai',
      taluk: 'Vadipatti',
      village: 'Alangottaram',
      workDate: DateTime.now().add(const Duration(days: 1)),
      workingHours: '7:30 AM - 1:30 PM',
      workersRequired: 8,
      workersHired: 3,
      wageAmount: 650.0,
      wageBasis: 'daily',
      description: 'பொன்னி நெல் அறுவடை பணி. மதிய உணவு மற்றும் தேநீர் வழங்கப்படும்.',
      contactPhone: '+919842100001',
      status: 'open',
    ),
    JobModel(
      id: 'job-102',
      employerId: 'owner-kullapuram',
      titleTa: 'கரும்பு வெட்டும் ஆட்கள் தேவை',
      titleEn: 'Sugarcane Cutting Labor Required',
      workType: 'harvesting',
      district: 'Madurai',
      taluk: 'Vadipatti',
      village: 'Kullapuram',
      workDate: DateTime.now().add(const Duration(days: 2)),
      workingHours: '7:00 AM - 2:00 PM',
      workersRequired: 12,
      workersHired: 4,
      wageAmount: 700.0,
      wageBasis: 'daily',
      description: 'ஆலைக்கு அனுப்ப கரும்பு வெட்ட வேண்டும். வாகன வசதி உண்டு.',
      contactPhone: '+919842100002',
      status: 'open',
    ),
    JobModel(
      id: 'job-103',
      employerId: 'owner-thanjavur',
      titleTa: 'பயிர் நடவு மற்றும் களையெடுத்தல்',
      titleEn: 'Transplanting & De-weeding',
      workType: 'weeding',
      district: 'Thanjavur',
      taluk: 'Papanasam',
      village: 'Vazhuthur',
      workDate: DateTime.now().add(const Duration(days: 1)),
      workingHours: '8:00 AM - 1:00 PM',
      workersRequired: 6,
      workersHired: 1,
      wageAmount: 500.0,
      wageBasis: 'daily',
      description: 'வயலில் களை பறித்தல் மற்றும் வரப்பு வெட்டுதல்.',
      contactPhone: '+919842100003',
      status: 'open',
    ),
    JobModel(
      id: 'job-104',
      employerId: 'owner-pollachi',
      titleTa: 'தென்னை மரம் ஏறுதல் மற்றும் தேங்காய் பறிப்பு',
      titleEn: 'Coconut Tree Climbing & Harvesting',
      workType: 'machinery',
      district: 'Coimbatore',
      taluk: 'Pollachi',
      village: 'Anaimalai',
      workDate: DateTime.now().add(const Duration(days: 3)),
      workingHours: '7:00 AM - 12:00 PM',
      workersRequired: 3,
      workersHired: 0,
      wageAmount: 900.0,
      wageBasis: 'daily',
      description: 'தென்னந்தோப்பில் தேங்காய் பறிக்க அனுபவம் உள்ள ஆட்கள்.',
      contactPhone: '+919842100004',
      status: 'open',
    ),
  ];

  final List<JobApplicationModel> _localApplications = [];

  Future<List<JobModel>> fetchJobs({
    String? district,
    String? village,
    String? workType,
  }) async {
    if (SupabaseConfig.isConfigured) {
      try {
        var query = Supabase.instance.client
            .from('jobs')
            .select()
            .eq('status', 'open');

        if (district != null && district.isNotEmpty) {
          query = query.eq('district', district);
        }
        if (village != null && village.isNotEmpty) {
          query = query.eq('village', village);
        }

        final res = await query.order('created_at', ascending: false);
        final list = (res as List).map((j) => JobModel.fromJson(j)).toList();

        // Cache for offline access
        await StorageService.cacheData('jobs', jsonEncode(res));
        return list;
      } catch (_) {}
    }

    // Try offline cache or fallback seed list
    final cached = StorageService.getCachedData('jobs');
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as List;
        return decoded.map((j) => JobModel.fromJson(j)).toList();
      } catch (_) {}
    }

    // Filter seed list
    return _sampleJobs.where((j) {
      if (workType != null && workType.isNotEmpty && j.workType != workType) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<bool> createJob(JobModel job) async {
    _sampleJobs.insert(0, job);
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client.from('jobs').insert(job.toJson());
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  Future<bool> applyForJob(JobApplicationModel app) async {
    _localApplications.add(app);
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client.from('job_applications').insert(app.toJson());
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  Future<List<JobApplicationModel>> fetchMyApplications(String workerId) async {
    if (SupabaseConfig.isConfigured) {
      try {
        final res = await Supabase.instance.client
            .from('job_applications')
            .select()
            .eq('worker_id', workerId)
            .order('applied_at', ascending: false);
        return (res as List).map((a) => JobApplicationModel.fromJson(a)).toList();
      } catch (_) {}
    }
    return _localApplications.where((a) => a.workerId == workerId).toList();
  }
}
