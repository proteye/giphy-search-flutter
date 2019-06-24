import 'dart:async';
import 'package:flutter/material.dart';

const DEFAULT_TIMEOUT = 2000; // as ms

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final int timeoutMs;

  SearchBar({Key key, this.onChanged, this.focusNode, this.timeoutMs})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchController = TextEditingController();
  String _text = '';
  Duration _duration;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _duration = Duration(milliseconds: widget.timeoutMs ?? DEFAULT_TIMEOUT);
    _searchController.addListener(_searchListener);
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    _searchController.dispose();
    super.dispose();
  }

  void _handleTimeout() {
    if (widget.onChanged != null) {
      widget.onChanged(_text);
    }
  }

  void _searchListener() {
    if (_searchController.text == _text) {
      return;
    }
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = new Timer(_duration, _handleTimeout);
    _text = _searchController.text.isNotEmpty ? _searchController.text : '';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        focusNode: widget.focusNode ?? null,
        controller: _searchController,
        autocorrect: false,
        autofocus: true,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration.collapsed(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white70),
        ));
  }
}
