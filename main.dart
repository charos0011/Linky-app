import 'package:flutter/material.dart';

void main() => runApp(const LinkyApp());

class LinkyApp extends StatelessWidget {
  const LinkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linky',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A89F3)),
        useMaterial3: true,
      ),
      home: const LockScreen(),
    );
  }
}

class AppState {
  static String pin = '1234';
  static String name = 'Kamolaxon';
  static String nick = '@kamolaxon_linky';
  static String phone = '+998 94 996 63 38';
  static int followers = 1240;
  static int following = 185;

  static final List users = [
    {
      'id': '1',
      'name': 'Aziza Karimova',
      'nick': '@aziza_k',
      'phone': '+998 90 123 45 67',
      'online': true,
      'followed': true,
      'lastMsg': 'Salom! Yangi videoni kordingizmi?',
      'msgs': ['Salom! Yangi videoni kordingizmi?', 'Ha, juda zor chiqibdi!'],
    },
    {
      'id': '2',
      'name': 'Sardorbek',
      'nick': '@sardor_pro',
      'phone': '+998 91 555 44 33',
      'online': true,
      'followed': false,
      'lastMsg': 'Bugun chatda korishamizmi?',
      'msgs': ['Bugun chatda korishamizmi?'],
    },
    {
      'id': '3',
      'name': 'Madina',
      'nick': '@madina_vibe',
      'phone': '+998 93 777 88 99',
      'online': false,
      'followed': false,
      'lastMsg': 'Linky ilovasi yoqdi.',
      'msgs': ['Linky ilovasi yoqdi.'],
    },
  ];

  static final List chats = [users[0], users[1], users[2]];

  static final List stories = [
    {'author': 'Aziza Karimova', 'text': 'Yangi post joyladim!'},
    {'author': 'Sardorbek', 'text': 'Onlaynman, yozavering!'},
  ];
}

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _ctrl = TextEditingController();

  void _unlock() {
    if (_ctrl.text.trim() == AppState.pin) {
      _ctrl.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Parol noto'g'ri (1234)")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A89F3),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 68, color: Colors.white),
            const SizedBox(height: 14),
            const Text(
              'Linky',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ctrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 22),
              decoration: InputDecoration(
                hintText: 'PIN kod',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0x33FFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (v) => _unlock(),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _unlock,
                child: const Text('Ochish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 2;
  final _titles = ['Linky - Lenta', 'Linky - Qidiruv', 'Linky - Chat', 'Linky - Profil'];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const FeedTab(),
      SearchTab(onChanged: () => setState(() {})),
      const ChatTab(),
      ProfileTab(onChanged: () => setState(() {})),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_idx]),
        backgroundColor: const Color(0xFF4A89F3),
        foregroundColor: Colors.white,
      ),
      body: pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A89F3),
        onTap: (i) => setState(() => _idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Lenta'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Qidiruv'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
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
    {
      'author': 'Aziza Karimova',
      'text': 'Linky ilovasini sinab koryapmiz!',
      'likes': 18,
      'liked': false,
    },
    {
      'author': 'Sardorbek',
      'text': 'Yangi chat va lenta juda qulay.',
      'likes': 27,
      'liked': false,
    },
  ];

  void _addStory() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yangi istoriya'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Matn...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  AppState.stories.insert(0, {
                    'author': AppState.name,
                    'text': ctrl.text.trim(),
                  });
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

  void _addPost() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yangi post'),
        content: TextField(
          controller: ctrl,
          maxLines: 2,
          decoration: const InputDecoration(hintText: 'Post matni...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  _posts.insert(0, {
                    'author': AppState.name,
                    'text': ctrl.text.trim(),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 86,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: AppState.stories.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return GestureDetector(
                    onTap: _addStory,
                    child: const SizedBox(
                      width: 68,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFF4A89F3),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Istoriya',
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final s = AppState.stories[i - 1];
                final author = (s['author'] ?? '').toString();
                return GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(author),
                      content: Text((s['text'] ?? '').toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Yopish'),
                        ),
                      ],
                    ),
                  ),
                  child: SizedBox(
                    width: 68,
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Text(author.isNotEmpty ? author.substring(0, 1) : '?'),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          author,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
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
              itemBuilder: (context, i) {
                final p = _posts[i];
                final liked = p['liked'] == true;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      p['author'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(p['text'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            color: liked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => setState(() {
                            p['liked'] = !liked;
                            p['likes'] = (p['likes'] as int) + (liked ? -1 : 1);
                          }),
                        ),
                        Text('${p['likes']}'),
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
        onPressed: _addPost,
        backgroundColor: const Color(0xFF4A89F3),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchTab extends StatefulWidget {
  final VoidCallback onChanged;
  const SearchTab({super.key, required this.onChanged});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _q = '';

  void _toggleFollow(dynamic u) {
    setState(() {
      final f = u['followed'] == true;
      u['followed'] = !f;
      AppState.following += f ? -1 : 1;
      AppState.followers += f ? -1 : 1;
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final s = _q.toLowerCase().trim();
    final list = AppState.users.where((u) {
      return u['name'].toString().toLowerCase().contains(s) ||
          u['nick'].toString().toLowerCase().contains(s) ||
          u['phone'].toString().toLowerCase().contains(s);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Ism, @nikname yoki raqam...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (v) => setState(() => _q = v),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final u = list[i];
              final online = u['online'] == true;
              final followed = u['followed'] == true;
              return ListTile(
                leading: Stack(
                  children: [
                    const CircleAvatar(child: Icon(Icons.person)),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: online ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                title: Text(u['name'].toString()),
                subtitle: Text("${u['nick']} • ${online ? 'Onlayn' : 'Oflayn'}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _toggleFollow(u),
                      child: Text(followed ? 'Obunada' : "Obuna bo'lish"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat, color: Color(0xFF4A89F3)),
                      onPressed: () {
                        if (!AppState.chats.any((c) => c['id'] == u['id'])) {
                          AppState.chats.insert(0, u);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DirectChatPage(user: u),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  ],
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
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final s = _q.toLowerCase().trim();
    final list = s.isEmpty
        ? AppState.chats
        : AppState.users.where((u) {
            return u['name'].toString().toLowerCase().contains(s) ||
                u['nick'].toString().toLowerCase().contains(s) ||
                u['phone'].toString().toLowerCase().contains(s);
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: '@nikname yoki +998 raqam orqali qidiring',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (v) => setState(() => _q = v),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final u = list[i];
              final online = u['online'] == true;
              final inChats = AppState.chats.any((c) => c['id'] == u['id']);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: Stack(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: online ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    u['name'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${online ? 'Onlayn' : 'Oflayn'} • ${u['lastMsg'] ?? ''}",
                  ),
                  onTap: () {
                    if (!inChats) {
                      setState(() => AppState.chats.insert(0, u));
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DirectChatPage(user: u),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  trailing: inChats
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => setState(() {
                            AppState.chats.removeWhere((c) => c['id'] == u['id']);
                          }),
                        )
                      : const Icon(Icons.person_add, color: Color(0xFF4A89F3)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DirectChatPage extends StatefulWidget {
  final dynamic user;
  const DirectChatPage({super.key, required this.user});

  @override
  State<DirectChatPage> createState() => _DirectChatPageState();
}

class _DirectChatPageState extends State<DirectChatPage> {
  final _ctrl = TextEditingController();

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isNotEmpty) {
      setState(() {
        final msgs = List.from(widget.user['msgs'] ?? []);
        msgs.add(t);
        widget.user['msgs'] = msgs;
        widget.user['lastMsg'] = t;
        _ctrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final msgs = List.from(widget.user['msgs'] ?? []);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['name'].toString()),
        backgroundColor: const Color(0xFF4A89F3),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (context, i) => Align(
                alignment: Alignment.centerRight,
                child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A89F3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    msgs[i].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      hintText: 'Xabar yozing...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onSubmitted: (v) => _send(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF4A89F3)),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  final VoidCallback onChanged;
  const ProfileTab({super.key, required this.onChanged});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  void _editProfile() {
    final nameCtrl = TextEditingController(text: AppState.name);
    final nickCtrl = TextEditingController(text: AppState.nick);
    final phoneCtrl = TextEditingController(text: AppState.phone);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profilni tahrirlash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Ism'),
            ),
            TextField(
              controller: nickCtrl,
              decoration: const InputDecoration(labelText: 'Nikname'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Telefon'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  AppState.name = nameCtrl.text.trim();
                  if (nickCtrl.text.trim().isNotEmpty) {
                    AppState.nick = nickCtrl.text.trim();
                  }
                  AppState.phone = phoneCtrl.text.trim();
                });
                widget.onChanged();
                Navigator.pop(context);
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
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(
          radius: 46,
          backgroundColor: Color(0xFF4A89F3),
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            AppState.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            AppState.nick,
            style: const TextStyle(color: Color(0xFF4A89F3)),
          ),
        ),
        Center(
          child: Text(
            AppState.phone,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Obunachilar: ${AppState.followers}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Obunalar: ${AppState.following}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Profilni tahrirlash'),
          onTap: _editProfile,
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Qulflash'),
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LockScreen()),
          ),
        ),
      ],
    );
  }
}
