import 'dart:async';
import 'package:flutter/material.dart';

const SEARCH_TIMEOUT = 2000; // as ms

class SearchBar extends StatefulWidget {
  SearchBar({Key key, this.onChanged, this.focusNode}) : super(key: key);

  final ValueChanged<String> onChanged;
  final FocusNode focusNode;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchController = TextEditingController();
  Duration _duration = const Duration(milliseconds: SEARCH_TIMEOUT);
  String _text = '';
  Timer _timer;

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
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return TextField(
        focusNode: widget.focusNode,
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
