import 'package:flutter/material.dart';

class CommunityChannelChat extends StatelessWidget {
  final bool isAdmin;

  const CommunityChannelChat({super.key, this.isAdmin = false});

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
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('📢', style: TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Community Channel",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _buildChannelMessageCard(),
                const SizedBox(height: 20),
                if (isAdmin) _buildMessageInput(),
              ],
            ),
          ),
          // Info bar for restrictions
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Only community admins can send messages. You can react and vote in polls.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelMessageCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "1 hour ago",
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
          const SizedBox(height: 7),
          const Text(
            "Shelter Alert",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow('📍', "Wat Sri Muang Temple Community Hall"),
          _buildInfoRow('👥', "Capacity: 20 spots free"),
          _buildInfoRow('🚰', "Drinking water, food, power"),
          _buildInfoRow('📏', "2.1 km from you"),
          _buildInfoRow('🛣️', "Road accessible"),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildReactionButton(Icons.arrow_upward, '4'),
              const SizedBox(width: 16),
              _buildReactionButton(Icons.arrow_downward, '5'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  elevation: 0,
                ),
                child: const Text("View", style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildReactionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(count, style: const TextStyle(fontSize: 15)),
      ],
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController _controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Write message as admin...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: () {
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
