import 'package:flutter/material.dart';
import 'community_channel_chat.dart'; // Channel UI
import 'com_chat1.dart'; // Community Chat UI

void main() => runApp(MaterialApp(home: ChatPage()));

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int selectedTab = 0;
  final List<String> tabs = ['All', 'Unread (0)', 'Recent (0)', 'Active (1)'];
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> chats = [
    {
      // Use the Material icon for Community Chat
      'avatar': Icons.groups,
      'isIcon': true,
      'title': 'Community Chat',
      'subtitle': 'Shelter Alert !!!',
      'time': 'Just now',
      'color': Colors.purple,
      'active': false,
    },
    {
      // Use emoji for Channel
      'avatar': '📢',
      'isIcon': false,
      'title': 'Channel',
      'subtitle': 'Welcome!',
      'time': 'Today',
      'color': Colors.blue,
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Messages",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search conversations...",
                filled: true,
                fillColor: Colors.grey.shade200,
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tabs[index]),
                      selected: selectedTab == index,
                      selectedColor: Colors.blue.shade100,
                      onSelected: (_) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Recent Chats",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return Card(
                    elevation: 0.0,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: chat['color'] as Color,
                        child: chat['isIcon'] == true
                            ? Icon(
                                chat['avatar'],
                                color: Colors.white,
                                size: 22,
                              )
                            : Text(
                                chat['avatar'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                      ),
                      title: Text(
                        chat['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(chat['subtitle']),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            chat['time'],
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (chat['active'] == true)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        if (chat['title'] == 'Community Chat') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CommunityChat(),
                            ),
                          );
                        } else if (chat['title'] == 'Channel') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CommunityChannelChat(isAdmin: false),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
