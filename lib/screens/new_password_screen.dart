import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/media_query/context_extensiton.dart';

class NewPasswordScreen extends StatefulWidget {
  final String title;
  final ValueChanged<String> onSubmitted;
  const NewPasswordScreen({
    super.key,
    required this.title,
    required this.onSubmitted,
  });

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _password = List.filled(6, '');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final text = _controller.text;
    if (text.length <= 6) {
      setState(() {
        for (int i = 0; i < _password.length; i++) {
          _password[i] = i < text.length ? text[i] : '';
        }
      });

      if (_password.every((char) => char.isNotEmpty)) {
        widget.onSubmitted.call(_password.join());
      }
    } else {
      _controller.text = _controller.text.substring(0, 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: HexColor(appBarColor),
      iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
      centerTitle: true,
      title: Text(
        widget.title,
        style: TextStyle(color: HexColor(appBarTitleColor)),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        SizedBox(
          height: context.dynamicHeight(0.12),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                _password.length,
                (index) => Padding(
                      padding: EdgeInsets.all(context.dynamicWidth(0.015)),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: HexColor(black), width: 2.0),
                              color: _password[index].isEmpty
                                  ? Colors.transparent
                                  : HexColor(black)),
                        ),
                      ),
                    ))),
        Offstage(
          offstage: true,
          child: TextField(
            focusNode: _focusNode,
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 6,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            autofocus: true,
            obscureText: true,
            style: const TextStyle(
              color: Colors.transparent,
              height: 0.01,
            ),
            cursorColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
