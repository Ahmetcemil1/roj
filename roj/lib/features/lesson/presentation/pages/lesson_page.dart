import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/tts_service.dart';

class LessonPage extends StatefulWidget {
  final int lessonId;
  const LessonPage({super.key, required this.lessonId});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  // Örnek Soru Verisi
  final List<Map<String, dynamic>> _questions = [
    {
      "type": "multiple_choice",
      "question": "Hangisi 'Elma' demektir?",
      "options": ["Sêv", "Nan", "Av", "Agir"],
      "answer": "Sêv",
    },
    {
      "type": "translate",
      "question": "'Ez diçim dibistanê' cümlesinin çevirisi nedir?",
      "options": ["Okula gidiyorum", "Eve geliyorum", "Okuldan geliyorum", "Su içiyorum"],
      "answer": "Okula gidiyorum",
    },
     {
      "type": "multiple_choice",
      "question": "Hangisi 'Su' demektir?",
      "options": ["Sêv", "Nan", "Av", "Agir"],
      "answer": "Av",
    },
  ];

  void _checkAnswer(String selectedAnswer) {
    bool isCorrect = selectedAnswer == _questions[_currentQuestionIndex]['answer'];
    
    if (isCorrect) {
      setState(() {
        _score += 10;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Doğru!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green, duration: Duration(milliseconds: 500)),
      );
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yanlış!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red, duration: Duration(milliseconds: 500)),
      );
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    // Puanları ve ilerlemeyi kaydet
    StorageService.addXp(_score);
    // Eğer başarılıysa bir sonraki seviyeyi aç (Basit mantık: >0 puan)
    if (_score > 0) {
      StorageService.unlockNextLevel(widget.lessonId);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Ders Tamamlandı!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.celebration, color: AppColors.primary, size: 60),
            const SizedBox(height: 16),
            Text("Puanın: $_score", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("İlerleme kaydedildi!"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dialog kapat
              Navigator.of(context).pop(); // Ana sayfaya dön
            },
            child: const Text("Tamam"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    double progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: LinearProgressIndicator(
          value: progress,
          color: AppColors.primary,
          backgroundColor: Colors.grey.shade200,
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
             IconButton(
              icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 32),
              onPressed: () {
                // Soru metnini değil, olası cevabın Kürtçesini okutmak daha mantıklı olabilir
                // Ya da soru kürtçeyse soruyu okut.
                // Basitlik için soruyu okutuyoruz (Eğer Kürtçe ise)
                TtsService.speak(question['question']);
              },
            ),
            const Spacer(),
            ...(question['options'] as List<String>).map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: Colors.grey, width: 2),
                    elevation: 0,
                  ),
                  child: Text(option),
                ),
              );
            }),
            const Spacer(),
            // Kontrol butonu (Otomatik check yaptığım için burası opsiyonel kaldı)
          ],
        ),
      ),
    );
  }
}
