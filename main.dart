import 'package:flutter/material.dart';

void main() {
  runApp(const LinkyApp());
}

class LinkyApp extends StatelessWidget {
  const LinkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linky',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A89F3)),
        useMaterial3: true,
      ),
      home: const LockScreen(child: LinkyMainPage()),
    );
  }
}

// ==========================================
// 1. 2 MARTALIK PIN O'RNATISH VA QULF EKRANI
// ==========================================
class LockScreen extends StatefulWidget {
  final Widget child;
  final String? initialSavedPin;

  const LockScreen({
    super.key,
    required this.child,
    this.initialSavedPin,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();

  late String _mode; // 'setup' -> 'confirm' -> 'unlock'
  String? _savedPin;
  String? _firstPin;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _savedPin = widget.initialSavedPin;
    _mode = (_savedPin != null && _savedPin!.isNotEmpty) ? 'unlock' : 'setup';
  }

  void _handleSubmit() {
    final enteredPin = _pinController.text.trim();

    if (enteredPin.length < 4) {
      setState(() {
        _errorText = 'Kamida 4 ta raqam kiriting';
      });
      return;
    }

    if (_mode == 'setup') {
      setState(() {
        _firstPin = enteredPin;
        _mode = 'confirm';
        _errorText = null;
        _pinController.clear();
      });
      return;
    }

    if (_mode == 'confirm') {
      if (enteredPin == _firstPin) {
        final confirmedPin = enteredPin;
        setState(() {
          _savedPin = confirmedPin;
          _firstPin = null;
          _mode = 'unlock';
          _errorText = null;
          _pinController.clear();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LinkyMainPage(activePin: confirmedPin),
          ),
        );
      } else {
        setState(() {
          _errorText = 'Parollar mos kelmadi, qaytadan kiriting';
          _pinController.clear();
        });
      }
      return;
    }

    if (_mode == 'unlock') {
      if (enteredPin == _savedPin) {
        setState(() {
          _errorText = null;
          _pinController.clear();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LinkyMainPage(activePin: _savedPin),
          ),
        );
      } else {
        setState(() {
          _errorText = 'Parol noto\'g\'ri';
          _pinController.clear();
        });
      }
    }
  }

  void _resetSetup() {
    setState(() {
      _firstPin = null;
      _errorText = null;
      _pinController.clear();
      _mode = 'setup';
    });
  }

  String get _titleText {
    if (_mode == 'setup') return 'Yangi PIN kod o\'rnating';
    if (_mode == 'confirm') return 'PIN kodni qayta kiriting';
    return 'PIN kodni kiriting';
  }

  String get _buttonText {
    if (_mode == 'setup') return 'Davom etish';
    if (_mode == 'confirm') return 'Tasdiqlash';
    return 'Kirish';
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
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
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _titleText,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: 'PIN kod (kamida 4 raqam)',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _handleSubmit(),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: const TextStyle(
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _handleSubmit,
                  child: Text(
                    _buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (_mode == 'confirm') ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _resetSetup,
                  child: const Text(
                    'Qaytadan o\'rnatish',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. ASOSIY ILOVA VA 4 TA BO'LIM
// ==========================================
class LinkyMainPage extends StatefulWidget {
  final String? activePin;
  const LinkyMainPage({super.key, this.activePin});

  @override
  State<LinkyMainPage> createState() => _LinkyMainPageState();
}

class _LinkyMainPageState extends State<LinkyMainPage> {
  int _selectedIndex = 0;

  final List> _posts = [
    {
      'author': 'Linky Official',
      'title': 'Linky ilovasiga xush kelibsiz!',
      'desc': 'Stories, Reels, qidiruv va shaxsiy xabarlar bir joyda.',
      'likes': 24,
      'liked': false,
      'isVideo': true,
    },
    {
      'author': 'Trend Reels',
      'title': 'Kunning eng mashhur qisqa videolari',
      'desc': 'Yangi videolar va foydali tavsiyalarni kuzatib boring.',
      'likes': 18,
      'liked': false,
      'isVideo': true,
    },
  ];

  void _addNewPost(String title, String desc) {
    setState(() {
      _posts.insert(0, {
        'author': 'Siz',
        'title': title,
        'desc': desc,
        'likes': 1,
        'liked': true,
        'isVideo': false,
      });
    });
  }

  void _showAddPostDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yangi post joylash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Sarlavha'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Matn'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                _addNewPost(
                  titleCtrl.text.trim(),
                  descCtrl.text.trim().isEmpty
                      ? 'Yangi post'
                      : descCtrl.text.trim(),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Joylash'),
          ),
        ],
      ),
    );
  }

  void _lockApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LockScreen(
          initialSavedPin: widget.activePin,
          child: LinkyMainPage(activePin: widget.activePin),
        ),
      ),
    );
  }

  void _resetPin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LockScreen(
          initialSavedPin: null,
          child: LinkyMainPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _FeedPage(
        posts: _posts,
        onToggleLike: (index) {
          setState(() {
            final liked = _posts[index]['liked'] as bool;
            _posts[index]['liked'] = !liked;
            _posts[index]['likes'] =
                (_posts[index]['likes'] as int) + (liked ? -1 : 1);
          });
        },
      ),
      _SearchPage(posts: _posts),
      const _MessagesPage(),
      _ProfilePage(
        postCount: _posts.where((p) => p['author'] == 'Siz').length,
        onResetPin: _resetPin,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Linky',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Post qo\'shish',
            onPressed: _showAddPostDialog,
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Ilovani qulflash',
            onPressed: _lockApp,
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Asosiy',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Qidiruv',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Xabarlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. ASOSIY LENTA (STORIES + REELS + POSTLAR)
// ==========================================
class _FeedPage extends StatelessWidget {
  final List> posts;
  final void Function(int index) onToggleLike;

  _FeedPage({
    required this.posts,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    final stories = ['Siz', 'Reels', 'Trend', 'Musiqa', 'Yangilik'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Stories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 84,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${stories[index]} story ochildi'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFF4A89F3),
                        child: Text(
                          stories[index][0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stories[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(posts.length, (index) {
          final post = posts[index];
          final liked = post['liked'] as bool;
          final isVideo = post['isVideo'] as bool;

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 10),
                      Text(
                        post['author'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isVideo)
                    Container(
                      height: 150,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A89F3).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          size: 54,
                          color: Color(0xFF4A89F3),
                        ),
                      ),
                    ),
                  Text(
                    post['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(post['desc'] as String),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? Colors.red : null,
                        ),
                        onPressed: () => onToggleLike(index),
                      ),
                      Text('${post['likes']}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ==========================================
// 4. QIDIRUV BO'LIMI
// ==========================================
class _SearchPage extends StatefulWidget {
  final List> posts;

  _SearchPage({required this.posts});

  @override
  State<_SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.posts.where((p) {
      final title = (p['title'] as String).toLowerCase();
      final desc = (p['desc'] as String).toLowerCase();
      final q = _query.toLowerCase();
      return title.contains(q) || desc.contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Video, reels yoki post qidiring...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _query = val.trim();
              });
            },
          ),
          const SizedBox(height: 14),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Hech narsa topilmadi'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.play_arrow),
                          title: Text(item['title'] as String),
                          subtitle: Text(item['desc'] as String),
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

// ==========================================
// 5. XABARLAR BO'LIMI
// ==========================================
class _MessagesPage extends StatefulWidget {
  const _MessagesPage();

  @override
  State<_MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<_MessagesPage> {
  final TextEditingController _msgCtrl = TextEditingController();
  final List<String> _messages = [
    'Salom! Linky chatiga xush kelibsiz.',
  ];

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(text);
      _msgCtrl.clear();
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return Align(
                alignment: index == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                                      ),
                  decoration: BoxDecoration(
                    color: index == 0
                        ? Colors.grey.shade200
                        : const Color(0xFF4A89F3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _messages[index],
                    style: TextStyle(
                      color: index == 0 ? Colors.black87 : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  decoration: InputDecoration(
                    hintText: 'Xabar yozing...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 6. PROFIL BO'LIMI
// ==========================================
class _ProfilePage extends StatefulWidget {
  final int postCount;
  final VoidCallback onResetPin;

  const _ProfilePage({
    required this.postCount,
    required this.onResetPin,
  });

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  String _username = 'Linky foydalanuvchisi';
  int _followers = 128;
  bool _isFollowing = false;

  void _editName() {
    final ctrl = TextEditingController(text: _username);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ismni o\'zgartirish'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  _username = ctrl.text.trim();
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Saqlash'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFF4A89F3),
            child: Icon(Icons.person, size: 42, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: _editName,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '${widget.postCount}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Postlar'),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$_followers',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Obunachilar'),
                ],
              ),
              const Column(
                children: [
                  Text(
                    '15',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Obunalar'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isFollowing = !_isFollowing;
                  _followers += _isFollowing ? 1 : -1;
                });
              },
              child: Text(_isFollowing ? 'Obuna bo\'lingan' : 'Obuna bo\'lish'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onResetPin,
              icon: const Icon(Icons.password),
              label: const Text('PIN kodni yangidan o\'rnatish'),
            ),
          ),
        ],
      ),
    );
  }
}
