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
    final size = MediaQuery.of(context).size;
    final logoSize = size.shortestSide / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('用爱发电'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/applogo.png',
                width: logoSize,
                height: logoSize,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_username != null) Text('用户名: $_username'),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle purchase link tap
                  },
                  child: const Text(
                    '赞助',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(labelText: '订单号'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle confirm button press
              },
              child: const Text('使用订单号获取金币'),
            ),
            const SizedBox(height: 20),
            Text('注意！！请核实您的账号是否正确，每个订单号只能使用一次。\n有任何疑问请在下载地址和游戏作者取得联系, 赞助平台不会做任何回复，在赞助平台私聊会被拉黑。\n提前感谢您的点赞！版本: $_version'),
          ],
        ),
      ),
    );
  }
}
