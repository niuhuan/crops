import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:url_launcher/url_launcher.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  String _version = '';
  String? _username;
  final TextEditingController _orderController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  Future<void> _showConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认'),
          content: const Text('已经耐心读完注意事项并严格遵守'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      const url = 'https://ifdian.net/a/ImpactMaster';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Future<void> _confirmOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('确认'),
            content: const Text('订单将会绑定用户名，一旦操作无法撤销，是否继续？'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );

      if (result == true) {
        try {
          final response = await Dio().post(
            'https://lnaxq5lypumytjsylhvwxh5x3e0brvjs.lambda-url.ap-northeast-2.on.aws/',
            data: {
              'username': _username,
              'orderNumber': _orderController.text.trim(),
            },
            options: Options(responseType: ResponseType.plain),
          );
          var msg = "";
          switch (response.data.toString()) {
            case "FAIL":
              msg = "订单号无效";
              break;
            case "DUPLICATE":
              msg = "订单号已经使用过";
              break;
            case "SUCCESS":
              msg = "金币已经发放，请在游戏中查看";
              break;
            default:
              msg = "未知错误 ${response.data.toString()}";
          }
          Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 10, // Extend the display time to 10 seconds
          );
        } catch (e) {
          Fluttertoast.showToast(
            msg: '请求失败: $e',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 10, // Extend the display time to 10 seconds
          );
        }
      }
    }
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
        child: Form(
          key: _formKey,
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
                    margin: const EdgeInsets.only(left: 20),
                  ),
                  GestureDetector(
                    onTap: _showConfirmationDialog,
                    child: const Text(
                      '赞助',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                  ),
                  GestureDetector(
                    onTap: () async {
                      const url = "https://github.com/niuhuan/crops/releases";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Text(
                      '加入组群、联系我',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _orderController,
                decoration: const InputDecoration(labelText: '订单号'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入订单号';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmOrder,
                child: const Text('使用订单号获取金币'),
              ),
              const SizedBox(height: 20),
              Text(
                  '!!!!!注意!!!!!\n * 每个订单号只能使用一次。\n * 点击赞助平台的个人中心->我的订单，复制订单号，订单号就是密钥。\n * 在上面取得金币后其他游戏也会同步发电，需要手动点击“曾经发过电”同步，但是请**务必核实**上方的用户名和其他游戏发电中心的用户名是否一致。\n * 新版本的其他游戏也可以直接使用订单号兑换金币，需要选择“刚才发了电”。\n * 请确认您已经加入群聊，有任何疑问请在下载地址和游戏作者取得联系, 赞助时不要捎带任何话，不要私聊，赞助平台不会做任何回复，如不遵守会被拉黑。\n * 提前感谢您的点赞！版本: $_version'),
              const SizedBox(height: 20),
              const Text(
                '浏览器内容清空以后，需要重新登录，金币可能会丢失，打赏时您已经悉知，请备份好用户名和浏览器数据！',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
