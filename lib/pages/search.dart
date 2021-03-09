import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _firestore = FirebaseFirestore.instance;
  final searchController = TextEditingController();
  Stream search;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
            autofocus: false,
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search Users here......',
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  searchController.clear();
                },
              ),
              prefixIcon: Icon(Icons.account_box),
              border: InputBorder.none,
              filled: true,
            ),
            onSubmitted: (String inpute) {
              Stream searchUsers = _firestore
                  .collection('User')
                  .where('username', isGreaterThanOrEqualTo: inpute)
                  .snapshots();
              setState(() {
                search = searchUsers;
              });
            }),
      ),
      body: search != null
          ? UserResult(
              search: search,
            )
          : Container(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [],
                ),
              ),
            ),
    );
  }
}

class UserResult extends StatelessWidget {
  UserResult({this.search});
  final Stream search;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: search,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          }
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 2.0,
              color: Colors.white10,
            ),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Image.network(
                      "${snapshot.data.docs[index].data()['photoUrl']}"),
                  radius: 20.0,
                ),
                title: Text(
                  "${snapshot.data.docs[index].data()['displayName']}",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                subtitle: Text(
                  "${snapshot.data.docs[index].data()['username']}",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                trailing: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.messenger),
                  onPressed: () {},
                ),
                onTap: () {},
                tileColor: Theme.of(context).primaryColor.withOpacity(0.7),
              );
            },
          );
        },
      ),
    );
  }
}
