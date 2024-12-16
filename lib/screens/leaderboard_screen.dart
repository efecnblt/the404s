import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/users.dart';
import '../services/auth_service.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaderboardPage extends StatefulWidget {
    final bool isDark;
  final AppLocalizations? localizations;
  final String userId;
  const LeaderboardPage({super.key,
    required this.isDark,
    required this.localizations,
    required this.userId,});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<app_user.User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = AuthService.getUserData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {

   

    
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      
      body: SafeArea(
        child: FutureBuilder<app_user.User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${widget.localizations!.anErrorOccured} ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  widget.localizations!.userDataNotFound,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else {
              final user = snapshot.data!;
              return Scaffold(
                backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title:  Text(widget.localizations!.leaderboard),
        centerTitle: true,
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        elevation: 0,
        foregroundColor: widget.isDark ? Colors.white : Colors.black,
      ),
      body: Column(
        children: [
          // Current User Bilgisi
          _buildCurrentUserSection(user),
          const Divider(),
          // Top 10 Users Listesi
          Expanded(
            child: ListView.builder(
              itemCount: top10Users.length,
              itemBuilder: (context, index) {
                return _buildTopUserRow(index + 1, top10Users[index]);
              },
            ),
          ),
        ],
      ),
    );
            }
          },
        ),
      ),
    );
  }
  Widget _buildCurrentUserSection( user) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.isDark ? Color(0xFF2F2F2F) : Colors.white,
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
                            radius: 40,
                            backgroundImage:    
                                 NetworkImage(user.imageUrl) as ImageProvider,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style:  TextStyle(color: widget.isDark? Colors.white: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('${widget.localizations!.rank}: {user.rank}',
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 16),
                  Text('${widget.localizations!.points}: {user[points]}',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopUserRow(int position,  user) {
    Divider(
      color: widget.isDark ? Colors.grey:Colors.black,
      height: 3,
    );
    return ListTile(
      tileColor: widget.isDark? Color(0xFF2F2F2F): Colors.white,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[200],
        child: position <= 3
            ? Image.asset(
                'assets/medal_$position.png', // Ödül simgeleri için (isteğe bağlı)
                width: 24,
                height: 24,
              )
            : Text(
                position.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
      ),
      title: Text(
        "user.name",
        style:  TextStyle(color: widget.isDark? Colors.white: Colors.black,fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        'user.points',
        style:  TextStyle(
          color: widget.isDark? Colors.white: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.all(7),
      
    );
  }
   

    // Statik boş top10 kullanıcı listesi
    final List<Map<String, dynamic>> top10Users = List.generate(
      10,
      (index) => {
        'name': 'User ${index + 1}',
        'points': '--',
      },
    );
  
}