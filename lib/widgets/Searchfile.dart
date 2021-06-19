import 'package:flutter/material.dart';

class Searchfile extends StatefulWidget {
  Searchfile({Key key}) : super(key: key);

  @override
  _SearchfileState createState() => _SearchfileState();
}

class _SearchfileState extends State<Searchfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Here"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){})
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  
  final cities = ["Pune", "Aurangabad", "Mumbai", "Nashik", "Nagpur", "Delhi"];
  final scities = ["Pune", "Mumbai", "Nashik"];
  
  @override
  List<Widget> buildActions(BuildContext context) {
      return [
        IconButton(icon: Icon(Icons.clear), onPressed: null)
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(icon: AnimatedIcon
      (icon: AnimatedIcons.menu_arrow,
      progress: null,),
      onPressed: null);
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // TODO: implement buildResults
      throw UnimplementedError();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    final suggestionlist = query.isEmpty ? scities : cities ;
    return ListView.builder(itemBuilder: (context, index) => ListTile(
      leading: Icon(Icons.location_city), title: Text(suggestionlist[index]),
    ),
    itemCount: suggestionlist.length,
    );
  }
  
}