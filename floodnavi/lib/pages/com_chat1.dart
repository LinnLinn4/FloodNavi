import 'package:flutter/material.dart';

class CommunityChat extends StatefulWidget {
  const CommunityChat({super.key});

  @override
  State<CommunityChat> createState() => _CommunityChatState();
}

class _CommunityChatState extends State<CommunityChat> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.groups, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              'Community Chat',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.info_outline, color: Colors.white),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildShelterAlertMessage(),
                ...messages.map((msg) => _buildMessageBubble(msg)).toList(),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildShelterAlertMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User avatar: green groups icon
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4CAF50),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name and time
                Row(
                  children: [
                    const Text(
                      'User120',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '1 hour ago',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                // const Text(
                //   'Shelter Alert',
                //   style: TextStyle(
                //     color: Colors.black87,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //   ),
                // ),
                const SizedBox(height: 5),
                Text(
                  "Are there anyone near Mae Sai Market?",
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
                // _buildInfoRow('📍', 'Wat Sri Muang Temple Community Hall'),
                // _buildInfoRow('👥', 'Capacity: 20 spots free'),
                // _buildInfoRow('🚰', 'Drinking water, food, power'),
                // _buildInfoRow('📏', '2.1 km from you'),
                // _buildInfoRow('🛣️', 'Road accessible'),
                // _buildInfoRow('⏳', 'Status: Pending'),
                // const SizedBox(height: 10),
                // Row(
                //   children: [
                //     // up arrow and number
                //     _buildReactionButton(Icons.arrow_upward, '4'),
                //     const SizedBox(width: 16),
                //     // down arrow and number
                //     _buildReactionButton(Icons.arrow_downward, '5'),
                //     const Spacer(),
                //     ElevatedButton(
                //       onPressed: () {},
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(0xFF4CAF50),
                //         foregroundColor: Colors.white,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(22),
                //         ),
                //         visualDensity: VisualDensity.compact,
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 20,
                //           vertical: 8,
                //         ),
                //         elevation: 0,
                //       ),
                //       child: const Text('View', style: TextStyle(fontSize: 15)),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildInfoRow(String emoji, String text) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 3),
  //     child: Row(
  //       children: [
  //         Text(emoji, style: const TextStyle(fontSize: 16)),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: const TextStyle(color: Colors.black87, fontSize: 14),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildReactionButton(IconData icon, String count) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(icon, color: Colors.black87, size: 21),
  //       if (count.isNotEmpty) ...[
  //         const SizedBox(width: 4),
  //         Text(
  //           count,
  //           style: const TextStyle(color: Colors.black87, fontSize: 16),
  //         ),
  //       ],
  //     ],
  //   );
  // }

  Widget _buildMessageBubble(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 56),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {},
              iconSize: 19,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF444444),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _handleSend,
              iconSize: 18,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(_messageController.text.trim());
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
