import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class RotatingSentenceList extends StatefulWidget {
  final String title;
  const RotatingSentenceList({super.key, required this.title});

  @override
  State<RotatingSentenceList> createState() => _RotatingSentenceListState();
}

class _RotatingSentenceListState extends State<RotatingSentenceList> {
  late Timer _timer;
  late PageController _pageController =
      PageController(initialPage: _currentIndex);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) %
            Provider.of<SentenceProvider>(context, listen: false)
                .sentences
                .length;
        if (_currentIndex == 0) {
          _pageController.jumpToPage(_currentIndex + 1);
        } else {
          _pageController.animateToPage(_currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SentenceProvider>(
      builder: (context, sentenceProvider, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: AppConstants.screenHeight * 0.5,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: sentenceProvider.sentences.length + 1,
                itemBuilder: (context, index) {
                  final currentIndex =
                      index % sentenceProvider.sentences.length;

                  if (index == sentenceProvider.sentences.length) {
                    return Container();
                  }

                  final previousIndex =
                      (currentIndex - 1 + sentenceProvider.sentences.length) %
                          sentenceProvider.sentences.length;

                  final nextIndex =
                      (currentIndex + 1) % sentenceProvider.sentences.length;

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            sentenceProvider.sentences[previousIndex],
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            sentenceProvider.sentences[nextIndex],
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          sentenceProvider.sentences[currentIndex],
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 163, 77, 233),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class SentenceProvider with ChangeNotifier {
  final List<String> sentences = [
    "Fark yaratan bir gelişim süreci",
    "Mesleki eğitimlerin yanı sıra kişisel ve profesyonel gelişim imkanı",
    "Çeşitlendirilmiş değerlendirme araçlarıyla gelişim alanlarını tanıma",
    "Codecademy ile uluslararası geçerliliğe sahip sertifika fırsatı",
    "Zengin eğitim kütüphanesi",
    "Online ve canlı derslerle hibrit yaklaşım",
    "Alanında uzman eğitmenlerle canlı dersler",
  ];
}
