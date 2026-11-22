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
      'isOnline': true,
      'isFollowed': true,
      'lastMessage': 'Salom! Yangi videoni kordingizmi?',
      'messages': [
        'Salom! Yangi videoni kordingizmi?',
        'Ha, juda zor chiqibdi!',
      ],
    },
    {
      'id': 'u2',
      'name': 'Sardorbek',
      'nickname': '@sardor_pro',
      'phone': '+998 91 555 44 33',
      'isOnline': true,
      'isFollowed': false,
      'lastMessage': 'Bugun kechqurun korishamizmi?',
      'messages': [
        'Bugun kechqurun korishamizmi?',
      ],
    },
    {
      'id': 'u3',
      'name': 'Madina',
      'nickname': '@madina_vibe',
      'phone': '+998 93 777 88 99',
      'isOnline': false,
      'isFollowed': false,
      'lastMessage': 'Linky ilovasi menga yoqdi.',
      'messages': [
        'Linky ilovasi menga yoqdi.',
      ],
    },
    {
      'id': 'u4',
      'name': 'Jasur',
      'nickname': '@jasur_dev',
      'phone': '+998 97 222 11 00',
      'isOnline': false,
      'isFollowed': false,
      'lastMessage': 'Yangi versiya tayyormi?',
      'messages': List.empty(growable: true),
    },
  ];

  static final List activeChats = [
    allUsers[0],
    allUsers[1],
    allUsers[2],
  ];

  static final List stories = [
    {
      'author': 'Aziza Karimova',
      'text': 'Bugun yangi post joyladim! Kirib koring.',
      'isOnline': true,
    },
    {
      'author': 'Sardorbek',
      'text': 'Linky chatda onlaynman, yozavering!',
      'isOnline': true,
    },
  ];
}

// 1. PAROL EKRANI
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
        MaterialPageRoute(
          builder: (context) => const MainHomeScreen(),
        ),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ilova uchun parolni kiriting',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  letterSpacing: 8,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '••••',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0x33FFFFFF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _checkPin,
                  child: const Text(
                    'Ochish',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. ASOSIY SAHIFA
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 2;
  final List _titles = [
    'Linky - Lenta',
    'Linky - Qidiruv',
    'Linky - Chat',
    'Linky - Profil',
  ];

  @override
  Widget build(BuildContext context) {
    final List pages = [
      const FeedTab(),
      SearchTab(
        onFollowChanged: () {
          setState(() {});
        },
      ),
      const ChatTab(),
      ProfileTab(
        onProfileUpdated: () {
          setState(() {});
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex].toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4A89F3),
        foregroundColor: Colors.white,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A89F3),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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

// 3. LENTA + HISTORIYALAR
class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  final List _posts = [
    {
      'author': 'Aziza Karimova',
      'text': 'Bugun ajoyib kun boldi! Linky ilovasini sinab koryapmiz.',
      'likes': 24,
      'liked': false,
    },
    {
      'author': 'Sardorbek',
      'text': 'Yangi qisqa videolar va dostlar bilan chat juda qulay ekan.',
      'likes': 41,
      'liked': false,
    },
  ];

  void _addStoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yangi istoriya joylash'),
          content: TextField(
            controller: controller,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Istoriya matnini yozing...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    AppState.stories.insert(0, {
                      'author': AppState.userName,
                      'text': controller.text.trim(),
                      'isOnline': true,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Joylashtirish'),
            ),
          ],
        );
      },
    );
  }

  void _viewStoryDialog(dynamic story) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(story['author'].toString()),
          content: Text(
            story['text'].toString(),
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Yopish'),
            ),
          ],
        );
      },
    );
  }

  void _addPostDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yangi post yozish'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Nimani ulashmoqchisiz?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _posts.insert(0, {
                      'author': AppState.userName,
                      'text': controller.text.trim(),
                      'likes': 0,
                      'liked': false,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Joylashtirish'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 96,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: AppState.stories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: _addStoryDialog,
                    child: Container(
                      width: 72,
                      margin: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: const [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0xFF4A89F3),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Istoriya',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final story = AppState.stories[index - 1];
                final String authorText = story['author'].toString();
                final String firstLetter =
                    authorText.isNotEmpty ? authorText.substring(0, 1) : '?';

                return GestureDetector(
                  onTap: () {
                    _viewStoryDialog(story);
                  },
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            firstLetter,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authorText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
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
                        Text(
                          post['author'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post['text'].toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  final nextLiked = !isLiked;
                                  post['liked'] = nextLiked;
                                  post['likes'] =
                                      nextLiked ? likesCount + 1 : likesCount - 1;
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
          ),
        ],
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

// 4. QIDIRUV + OBUNA BOLISH + ONLAYN HOLAT
class SearchTab extends StatefulWidget {
  final VoidCallback onFollowChanged;

  const SearchTab({super.key, required this.onFollowChanged});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _query = '';

  void _toggleFollow(dynamic user) {
    setState(() {
      final bool currentlyFollowed = user['isFollowed'] == true;
      user['isFollowed'] = !currentlyFollowed;
      if (!currentlyFollowed) {
        AppState.following += 1;
        AppState.followers += 1;
      } else {
        if (AppState.following > 0) AppState.following -= 1;
        if (AppState.followers > 0) AppState.followers -= 1;
      }
    });
    widget.onFollowChanged();
  }

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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _query = val;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final user = filtered[index];
              final bool isOnline = user['isOnline'] == true;
              final bool isFollowed = user['isFollowed'] == true;

              return ListTile(
                leading: Stack(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF4A89F3),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(user['name'].toString()),
                subtitle: Text(
                  "${user['nickname']} • ${isOnline ? 'Onlayn' : 'Oflayn'}",
                  style: TextStyle(
                    color: isOnline ? Colors.green[700] : Colors.grey,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        _toggleFollow(user);
                      },
                      child: Text(i
