import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final void Function(String)?  onChanged;
  const MySearchBar({Key? key, required this.searchController, this.onChanged}) : super(key: key);

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.searchController,
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
            hintText: "Search patients",
            suffixIcon: Icon(Icons.search),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            prefix: Padding(
                padding: EdgeInsets.only(left: 10, top: 0, bottom: 0)),
            contentPadding: EdgeInsets.all(0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )),
      ),
    );
  }
}
