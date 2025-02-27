import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'api.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  String _version = '';
  String? _username;
  final TextEditingController _orderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVersion();
    _username = apiService.getUsername();
  }

  Future<void> _loadVersion() async {
    final version = await rootBundle.loadString('assets/version.txt');
    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用爱发电'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_username != null) Text('用户名: $_username'),
            const SizedBox(height: 20),
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(labelText: '订单号'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Handle purchase link tap
              },
              child: const Text(
                '购买',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle confirm button press
              },
              child: const Text('确定'),
            ),
            const SizedBox(height: 20),
            Text('感谢您的点赞！\n版本: $_version'),
          ],
        ),
      ),
    );
  }
}
