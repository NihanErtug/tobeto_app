import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_event.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_state.dart';

class CompetencyTestResultPage extends StatefulWidget {
  const CompetencyTestResultPage({super.key});

  @override
  _CompetencyTestResultPageState createState() =>
      _CompetencyTestResultPageState();
}

class _CompetencyTestResultPageState extends State<CompetencyTestResultPage> {
  @override
  void initState() {
    super.initState();
    context.read<CompetencyTestBloc>().add(FetchCompetencyTestResult());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tobeto İşte Başarı Modeli'),
        backgroundColor: const Color(0xFFF3E5F5),
        centerTitle: true,
      ),
      body: BlocBuilder<CompetencyTestBloc, CompetencyTestState>(
        builder: (context, state) {
          if (state is CompetencyTestLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CompetencyTestResultFetched) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Tobeto İşte Başarı Modeli',
                      style: TextStyle(
                        color: Color(0xFF9933ff),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Analiz Raporum',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'lib/assets/images/competency_test_report.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    ...state.result.scores.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: getCategoryColor(entry.key),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  entry.value.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                getCategoryName(entry.key),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          } else if (state is CompetencyTestError) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Yeni dünyaya hazırlanıyorum':
        return Colors.blue;
      case 'Profesyonel duruşumu geliştiriyorum':
        return Colors.green;
      case 'Kendimi tanıyor ve yönetiyorum':
        return Colors.orange;
      case 'Yaratıcı ve doğru çözümler geliştiriyorum':
        return Colors.purple;
      case 'Kendimi sürekli geliştiriyorum':
        return Colors.pink;
      case 'Başkaları ile birlikte çalışıyorum':
        return Colors.red;
      case 'Sonuç ve başarı odaklıyım':
        return Colors.yellow;
      case 'Anlıyorum ve anlaşılıyorum':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String getCategoryName(String category) {
    switch (category) {
      case 'Yeni dünyaya hazırlanıyorum':
        return 'Yeni dünyaya hazırlanıyorum';
      case 'Profesyonel duruşumu geliştiriyorum':
        return 'Profesyonel duruşumu geliştiriyorum';
      case 'Kendimi tanıyor ve yönetiyorum':
        return 'Kendimi tanıyor ve yönetiyorum';
      case 'Yaratıcı ve doğru çözümler geliştiriyorum':
        return 'Yaratıcı ve doğru çözümler geliştiriyorum';
      case 'Kendimi sürekli geliştiriyorum':
        return 'Kendimi sürekli geliştiriyorum';
      case 'Başkaları ile birlikte çalışıyorum':
        return 'Başkaları ile birlikte çalışıyorum';
      case 'Sonuç ve başarı odaklıyım':
        return 'Sonuç ve başarı odaklıyım';
      case 'Anlıyorum ve anlaşılıyorum':
        return 'Anlıyorum ve anlaşılıyorum';
      default:
        return 'Bilinmeyen kategori';
    }
  }
}
