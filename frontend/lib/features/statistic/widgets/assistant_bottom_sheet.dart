import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../models/chat_message.dart';
import '../../../core/config/api_config.dart';

/// =====================================================
/// ASSISTANT BOTTOM SHEET
/// =====================================================
class AssistantBottomSheet extends StatefulWidget {
  final int tableId;
  final String tableTitle;

  const AssistantBottomSheet({
    super.key,
    required this.tableId,
    required this.tableTitle,
  });

  @override
  State<AssistantBottomSheet> createState() => _AssistantBottomSheetState();
}

class _AssistantBottomSheetState extends State<AssistantBottomSheet> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Dio _dio = Dio();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  // bool _hasError = false;

  @override
  void initState() {
    super.initState();

    // Pesan pembuka dari AI
    _messages.add(
      ChatMessage.ai(
        'Selamat datang di James Bond Data Portal. '
        'Saya Cong Wo, atau biasa dipanggil Kacong Bondowoso, '
        'asisten resmi Anda di portal data statistik dan informasi publik '
        'Kabupaten Bondowoso ini. Apa yang bisa saya bantu 😊',
      ),
    );

    // Auto scroll ke bawah setelah build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _animateAiResponse(String fullText) async {
    final index = _messages.length;

    setState(() {
      _messages.add(ChatMessage.ai(''));
    });

    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 18));

      if (!mounted) return;

      setState(() {
        _messages[index] = ChatMessage.ai(fullText.substring(0, i + 1));
      });

      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildChatList()),
              _buildQuickActions(),
              _buildInputBar(),
            ],
          ),
        );
      },
    );
  }

  /// =====================================================
  /// HEADER
  /// =====================================================
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: Color(0xFF007AFF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cong Wo',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D1D1F),
                          ),
                        ),
                        Text(
                          'Tabel ${widget.tableTitle}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF6E6E73),
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// CHAT LIST
  /// =====================================================
  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoading && index == _messages.length) {
          return _buildTypingIndicator();
        }

        final msg = _messages[index];
        return ChatCard(text: msg.text, isUser: msg.isUser);
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const TypingDots(),
    );
  }

  /// =====================================================
  /// QUICK ACTION CHIPS
  /// =====================================================
  Widget _buildQuickActions() {
    if (_isLoading || _messages.length > 2) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pertanyaan umum:',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _quickChip('Tabel ini tentang apa?'),
              _quickChip('Data ini untuk apa?'),
              _quickChip('Sumber datanya dari mana?'),
              _quickChip('Apa saja kolom yang ada?'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickChip(String text) {
    return GestureDetector(
      onTap: () => _sendMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF007AFF).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF007AFF).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF007AFF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// INPUT BAR
  /// =====================================================
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  _sendMessage(value);
                },
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Tanyakan tentang tabel ini...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: _isLoading
                      ? Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.all(12),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF007AFF),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      _sendMessage(_controller.text);
                    },
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// SEND MESSAGE + API CALL
  /// =====================================================
  Future<void> _sendMessage(String text) async {
    final message = text.trim();
    if (message.isEmpty || _isLoading) return;

    // Tambah pesan user
    setState(() {
      _messages.add(ChatMessage.user(message));
      _isLoading = true;
      // _hasError = false;
      _controller.clear();
    });

    _focusNode.unfocus();
    _scrollToBottom();

    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/chat',
        data: {'message': message, 'table_id': widget.tableId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final answer =
          response.data['answer'] ??
          'Tidak ada jawaban tersedia untuk pertanyaan ini.';

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      await _animateAiResponse(answer);
    } catch (e) {
      setState(() {
        // _hasError = true;
        _messages.add(
          ChatMessage.ai(
            'Maaf, terjadi gangguan saat memproses pertanyaan. '
            'Silakan coba lagi dalam beberapa saat.',
          ),
        );
      });
    } finally {
      _scrollToBottom();
    }
  }
}

/// =====================================================
/// CHAT CARD
/// =====================================================
class ChatCard extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatCard({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Color(0xFF007AFF),
                size: 16,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF007AFF) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isUser ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFF6E6E73),
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}

class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        int count = (_controller.value * 3).floor() + 1;
        return Text(
          '.' * count,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF007AFF),
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
