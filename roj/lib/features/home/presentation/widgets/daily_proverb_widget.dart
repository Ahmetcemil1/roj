import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../core/constants/app_colors.dart';

class DailyProverbWidget extends StatefulWidget {
  const DailyProverbWidget({super.key});

  @override
  State<DailyProverbWidget> createState() => _DailyProverbWidgetState();
}

class _DailyProverbWidgetState extends State<DailyProverbWidget> {
  // Veritabanı olmadığı için örnek liste
  final List<Map<String, String>> _proverbs = [
    {
      "ku": "Şêr şêr e, çi jin e çi mêr e.",
      "tr": "Aslan aslandır, ne kadındır ne erkek. (Kadın erkek eşittir)"
    },
    {
      "ku": "Bi pirsê, mirov diçe Qudsê.",
      "tr": "Sora sora Bağdat bulunur. (Sormakla insan Kudüs'e gider)"
    },
    {
      "ku": "Dinya li ser hêviyê hatiye avakirin.",
      "tr": "Dünya umut üzerine kurulmuştur."
    },
     {
      "ku": "Nan nîne, pîvaz nîne, çi ji vê dinyayê fêm kirine?",
      "tr": "Ekmek yok, soğan yok, ne anladılar bu dünyadan? (Fakirliğe sitem)"
    },
  ];

  late Map<String, String> _dailyProverb;

  @override
  void initState() {
    super.initState();
    // Rastgele bir tane seç (Her gün değişmesi için tarih bazlı logic kurulabilir)
    _dailyProverb = _proverbs[Random().nextInt(_proverbs.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                "Gotinên Pêşiyan (Günün Sözü)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _dailyProverb['ku']!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _dailyProverb['tr']!,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
