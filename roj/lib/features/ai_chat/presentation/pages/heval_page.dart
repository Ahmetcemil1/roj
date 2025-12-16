import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HevalPage extends StatefulWidget {
  const HevalPage({super.key});

  @override
  State<HevalPage> createState() => _HevalPageState();
}

class _HevalPageState extends State<HevalPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Mesaj geçmişi
  final List<Content> _history = [];
  final List<Map<String, String>> _messagesForUi = []; // UI için basit model
  
  bool _isLoading = false;
  String? _apiKey;
  GenerativeModel? _model;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKey = prefs.getString('gemini_api_key');
      if (_apiKey != null) {
        _initModel();
      } else {
        // UI'da ilk mesaj
        _messagesForUi.add({
          "role": "ai", 
          "content": "Rojbaş! Ez Heval im. Ji kerema xwe mifteya API ya Gemini binivîse. (Merhaba! Ben Heval. Lütfen Gemini API anahtarını girin.)"
        });
      }
    });
  }

  void _initModel() {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey!);
    // Başlangıç promptu ile modeli eğit (ChatContext)
    _messagesForUi.add({
       "role": "ai",
       "content": "Rojbaş! Ez amade me bi Kurdî biaxivim. (Hazırım, Kürtçe konuşabiliriz.)"
    });
  }

  Future<void> _saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', key);
    setState(() {
      _apiKey = key;
    });
    _initModel();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    // 1. API Key yoksa, girilen metni Key olarak kabul et
    if (_apiKey == null) {
      await _saveApiKey(text);
      return;
    }

    // 2. Mesajı UI'a ekle
    setState(() {
      _messagesForUi.add({"role": "user", "content": text});
      _isLoading = true;
    });
    _scrollToBottom();

    // 3. AI'ya gönder
    try {
      final chat = _model!.startChat(history: _history);
      // Modele 'Kürtçe cevap ver' talimatını gizlice ekleyebiliriz veya kullanıcıya bırakırız.
      // Burada direkt kullanıcı mesajını iletiyoruz.
      final response = await chat.sendMessage(Content.text("Please respond in Kurdish (Kurmanji) if possible, or Turkish explaining Kurdish grammar: $text"));
      
      final answer = response.text;

      if (answer != null) {
        setState(() {
          _messagesForUi.add({"role": "ai", "content": answer});
          _history.add(Content.model([TextPart(answer)]));
          _history.add(Content.text(text)); // Geçmişi senkronize tut
        });
      }
    } catch (e) {
      setState(() {
        _messagesForUi.add({"role": "ai", "content": "Hata oluştu: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: AppColors.primary),
            SizedBox(width: 8),
            Text("Heval (Gemini AI)"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.key),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('gemini_api_key');
              setState(() => _apiKey = null);
              // Sayfayı yenile veya uyarı ver
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messagesForUi.length,
              itemBuilder: (context, index) {
                final msg = _messagesForUi[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primary : Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isUser ? 12 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 12),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                      ]
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    child: Text(
                      msg['content']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _apiKey == null ? "Gemini API Key yapıştır..." : "Kürtçe bir şeyler sor...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: AppColors.secondary,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
