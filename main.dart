import 'package:flutter/material.dart';

void main() {
  runApp(const LinkyApp());
}

class LinkyApp extends StatelessWidget {
  const LinkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linky',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LockScreen(),
    );
  }
}

class AppState {
  static String pinCode = '1234';
  static String userName = 'Kamolaxon';
  static String userNickname = '@kamolaxon_linky';
  static String userPhone = '+998 94 996 63 38';
  static int followers = 1240;
  static int following = 185;

  static final List allUsers = [
    {
      'id': 'u1',
      'name': 'Aziza Karimova',
      'nickname': '@aziza_k',
      'phone': '+998 90 123 45 67',
      'lastMessage': 'Salom! Yangi videoni kordingizmi?',
      'messages': ['Salom! Yangi videoni kordingizmi?', 'Ha, juda zor chiqibdi!'],
    },
    {
      'id': 'u2',
      'name': 'Sardorbek',
      'nickname': '@sardor_pro',
      'phone': '+998 91 555 44 33',
      'lastMessage': 'Bugun kechqurun korishamizmi?',
      'messages': ['Bugun kechqurun korishamizmi?'],
    },
    {
      'id': 'u3',
      'name': 'Madina',
      'nickname': '@madina_vibe',
      'phone': '+998 93 777 88 99',
      'lastMessage': 'Linky ilovasi menga yoqdi.',
      'messages': ['Linky ilovasi menga yoqdi.'],
    },
    {
      'id': 'u4',
      'name': 'Jasur',
      'nickname': '@jasur_dev',
      'phone': '+998 97 222 11 00',
      'lastMessage': 'Yangi versiya tayyormi?',
      'messages': List.empty(growable: true),
    },
  ];

  static final List activeChats = [allUsers[0], allUsers[1], allUsers[2]];
}

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();

  void _checkPin() {
    if (_pinController.text.trim() == AppState.pinCode) {
      _pinController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainHomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Parol noto'g'ri! (Standart parol: 1234)"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A89F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 72, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Linky',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Ilova uchun parolni kiriting', style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, letterSpacing: 8, color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '••••',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0x33FFFFFF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
                onSubmitted: (_) => _checkPin(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A89F3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _checkPin,
                  child: const Text('Ochish', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 2;
  final List _titles = ['Linky - Lenta', 'Linky - Qidiruv', 'Linky - Chat', 'Linky - Profil'];

  @override
  Widget build(BuildContext context) {
    final List pages = [
      const FeedTab(),
      const SearchTab(),
      const ChatTab(),
      ProfileTab(onProfileUpdated: () => setState(() {})),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex].toString(), style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4A89F3),
        foregroundColor: Colors.white,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A89F3),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Lenta'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Qidiruv'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  final List _posts = [
    {'author': 'Aziza Karimova', 'text': 'Bugun ajoyib kun boldi! Linky ilovasini sinab koryapmiz.', 'likes': 24, 'liked': false},
    {'author': 'Sardorbek', 'text': 'Yangi qisqa videolar va dostlar bilan chat juda qulay ekan.', 'likes': 41, 'liked': false},
  ];

  void _addPostDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yangi post yozish'),
        content: TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: 'Nimani ulashmoqchisiz?')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _posts.insert(0, {'author': AppState.userName, 'text': controller.text.trim(), 'likes': 0, 'liked': false});
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Joylashtirish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final bool isLiked = post['liked'] == true;
          final int likesCount = (post['likes'] as int?) ?? 0;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['author'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(post['text'].toString(), style: const TextStyle(fontSize: 15)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.grey),
                        onPressed: () {
                          setState(() {
                            final nextLiked = !isLiked;
                            post['liked'] = nextLiked;
                            post['likes'] = nextLiked ? likesCount + 1 : likesCount - 1;
                          });
                        },
                      ),
                      Text('${post['likes']}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPostDialog,
        backgroundColor: const Color(0xFF4A89F3),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase().trim();
    final filtered = AppState.allUsers.where((user) {
      return user['name'].toString().toLowerCase().contains(q) ||
          user['nickname'].toString().toLowerCase().contains(q) ||
          user['phone'].toString().toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Ism, @nikname yoki raqam boyicha qidirish...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (val) => setState(() => _query = val),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final user = filtered[index];
              return ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFF4A89F3), child: Icon(Icons.person, color: Colors.white)),
                title: Text(user['name'].toString()),
                subtitle: Text("${user['nickname']} - ${user['phone']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.chat, color: Color(0xFF4A89F3)),
                  onPressed: () {
                    if (!AppState.activeChats.any((c) => c['id'] == user['id'])) {
                      AppState.activeChats.insert(0, user);
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DirectChatScreen(user: user)));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  String _searchText = '';

  void _deleteChat(dynamic chatUser) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suhbatni ochirish'),
        content: Text("${chatUser['name']} bilan suhbatni ochirmoqchimisiz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                AppState.activeChats.removeWhere((item) => item['id'] == chatUser['id']);
              });
              Navigator.pop(context);
            },
            child: const Text('Ochirish', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchText.toLowerCase().trim();
    final List displayList = query.isEmpty
        ? AppState.activeChats
        : AppState.allUsers.where((user) {
            return user['name'].toString().toLowerCase().contains(query) ||
                user['nickname'].toString().toLowerCase().contains(query) ||
                user['phone'].toString().toLowerCase().contains(query);
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: '@nikname yoki telefon raqam (+998...) orqali qidiring',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onChanged: (value) => setState(() => _searchText = value),
          ),
        ),
        Expanded(
          child: displayList.isEmpty
              ? const Center(child: Text('Suhbatdosh topilmadi', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final chatUser = displayList[index];
                    final isInActiveChats = AppState.activeChats.any((c) => c['id'] == chatUser['id']);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      child: ListTile(
                        leading: const CircleAvatar(backgroundColor: Color(0xFF4A89F3), child: Icon(Icons.person, color: Colors.white)),
                        title: Text(chatUser['name'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${chatUser['nickname']} - ${chatUser['phone']}\n${chatUser['lastMessage'] ?? 'Yangi suhbat'}"),
                        isThreeLine: true,
                        onTap: () {
                          if (!isInActiveChats) {
                            setState(() => AppState.activeChats.insert(0, chatUser));
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DirectChatScreen(user: chatUser))).then((_) => setState(() {}));
                        },
                        trailing: isInActiveChats
                            ? IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteChat(chatUser))
                            : const Icon(Icons.person_add_alt_1, color: Color(0xFF4A89F3)),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class DirectChatScreen extends StatefulWidget {
  final dynamic user;

  const DirectChatScreen({super.key, required this.user});

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        final List msgs = List.from(widget.user['messages'] ?? List.empty(growable: true));
        msgs.add(text);
        widget.user['messages'] = msgs;
        widget.user['lastMessage'] = text;
        _msgController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List messages = List.from(widget.user['messages'] ?? List.empty(growable: true));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['name'].toString(), style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4A89F3),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('Hali xabarlar yoq. Birinchi bolib yozing!', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: const Color(0xFF4A89F3), borderRadius: BorderRadius.circular(14)),
                          child: Text(messages[index].toString(), style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Xabar yozing...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send, color: Color(0xFF4A89F3)), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  const ProfileTab({super.key, required this.onProfileUpdated});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  void _editProfileDialog() {
    final nameController = TextEditingController(text: AppState.userName);
    final nickController = TextEditingController(text: AppState.userNickname);
    final phoneController = TextEditingController(text: AppState.userPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profilni tahrirlash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Ism')),
            TextField(controller: nickController, decoration: const InputDecoration(labelText: 'Nikname (@...)')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Telefon raqam')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  AppState.userName = nameController.text.trim();
                  final rawNick = nickController.text.trim();
                  if (rawNick.isNotEmpty) {
                    AppState.userNickname = rawNic
