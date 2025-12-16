import 'dart:convert';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/tts_service.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allWords = [];
  List<Map<String, dynamic>> _filteredWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      final String response = await DefaultAssetBundle.of(context).loadString('assets/data/dictionary.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _allWords = data.map((e) => Map<String, dynamic>.from(e)).toList();
        _filteredWords = _allWords;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading dictionary: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterWords(String query) {
    setState(() {
      _filteredWords = _allWords.where((word) {
        return word['ku']!.toLowerCase().contains(query.toLowerCase()) || 
               word['tr']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ferheng (Sözlük)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterWords,
              decoration: InputDecoration(
                hintText: "Kelime ara (Kürtçe veya Türkçe)",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredWords.length,
              separatorBuilder: (c, i) => const Divider(),
              itemBuilder: (context, index) {
                final word = _filteredWords[index];
                return ListTile(
                  title: Text(word['ku']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  subtitle: Text(word['tr']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: Colors.grey),
                    onPressed: () {
                      TtsService.speak(word['ku']!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
