import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. DATA MODEL
class Contact {
  final String name;
  final String phone;
  final String imageAsset;
  final bool isOnline;

  Contact({
    required this.name,
    required this.phone,
    required this.imageAsset,
    required this.isOnline,
  });
}

// 2. MOCK DATA
final List<Contact> contacts = [
  Contact(
    name: "Alaina Smith",
    phone: "089*******",
    imageAsset: "assets/images/person1.jpg",
    isOnline: true,
  ),
  Contact(
    name: "Benjamin Carter",
    phone: "081*******",
    imageAsset: "assets/images/person2.jpg",
    isOnline: false,
  ),
  Contact(
    name: "Chloe Davis",
    phone: "082*******",
    imageAsset: "assets/images/person3.jpg",
    isOnline: true,
  ),
  Contact(
    name: "David Rodriguez",
    phone: "085*******",
    imageAsset: "assets/images/person4.jpg",
    isOnline: false,
  ),
  Contact(
    name: "Emily White",
    phone: "087*******",
    imageAsset: "assets/images/person5.jpg",
    isOnline: true,
  ),
];

// 3. MAIN APP
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        cardColor: Colors.white,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF0F4F8),
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black54),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1C20),
        cardColor: const Color(0xFF24282E),
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1C20),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.grey),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: ContactsScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

// 4. CONTACTS SCREEN
class ContactsScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const ContactsScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> {
  int? _expandedIndex;
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = contacts;
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text;
    List<Contact> filteredList;
    if (query.isEmpty) {
      filteredList = contacts;
    } else {
      filteredList = contacts.where((contact) {
        return contact.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {
      _filteredContacts = filteredList;
      _expandedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color listBorderColor = widget.isDarkMode
        ? Colors.blue.shade300
        : Colors.blue.shade500;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isDarkMode
                    ? [Colors.blue.shade900, Colors.blue.shade700]
                    : [Colors.blue.shade400, Colors.blue.shade700],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Contacts",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        widget.isDarkMode
                            ? Icons.light_mode
                            : Icons.nightlight_round,
                        color: Colors.white,
                      ),
                      onPressed: widget.toggleTheme,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSearchBar(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                border: Border.all(color: listBorderColor, width: 2.0),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  return ContactCard(
                    contact: _filteredContacts[index],
                    isExpanded: _expandedIndex == index,
                    isDarkMode: widget.isDarkMode,
                    onTap: () {
                      setState(() {
                        if (_expandedIndex == index) {
                          _expandedIndex = null;
                        } else {
                          _expandedIndex = index;
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final searchBarColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final hintColor = widget.isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade500;
    final iconColor = widget.isDarkMode
        ? Colors.grey.shade300
        : Colors.grey.shade600;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        color: searchBarColor,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26), // Diganti dari withOpacity(0.1)
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: "Search contacts",
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(Icons.search, color: iconColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}

// 5. CONTACT CARD
class ContactCard extends StatelessWidget {
  final Contact contact;
  final bool isExpanded;
  final VoidCallback onTap;
  final bool isDarkMode;

  const ContactCard({
    super.key,
    required this.contact,
    required this.isExpanded,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = isDarkMode
        ? Colors.blue.shade300
        : Colors.blue.shade500;
    Color nameColor = Theme.of(context).textTheme.bodyMedium!.color!;
    Color phoneColor = Theme.of(context).textTheme.bodySmall!.color!;

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(contact.imageAsset),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: TextStyle(
                            color: nameColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact.phone,
                          style: TextStyle(color: phoneColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStatusBadge(contact.isOnline),
                ],
              ),
              if (isExpanded) _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isOnline) {
    final Color color = isOnline ? Colors.green : Colors.grey;
    final String text = isOnline ? "Online" : "Offline";
    final Color bgColor = isOnline
        ? (isDarkMode
              ? Colors.green.withAlpha(51) // Diganti dari withOpacity(0.2)
              : Colors.green.shade50)
        : (isDarkMode
              ? Colors.grey.withAlpha(51) // Diganti dari withOpacity(0.2)
              : Colors.grey.shade100);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    const Color navyBlue = Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${contact.name}...'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(minutes: 60),
                  action: SnackBarAction(
                    label: 'END CALL',
                    textColor: Colors.red,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.call, color: Colors.white, size: 20),
            label: const Text("Call"),
            style: ElevatedButton.styleFrom(
              backgroundColor: navyBlue,
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(contact: contact),
                ),
              );
            },
            icon: const Icon(Icons.message, color: Colors.white, size: 20),
            label: const Text("Message"),
            style: ElevatedButton.styleFrom(
              backgroundColor: navyBlue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// 6. Halaman Chat
class ChatScreen extends StatefulWidget {
  final Contact contact;

  const ChatScreen({super.key, required this.contact});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text);
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(widget.contact.imageAsset),
            ),
            const SizedBox(width: 12),
            Text(widget.contact.name),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [Colors.blue.shade900, Colors.blue.shade700]
                  : [Colors.blue.shade400, Colors.blue.shade700],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildChatBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withAlpha(26), // Diganti dari withOpacity(0.1)
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
