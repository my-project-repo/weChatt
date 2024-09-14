import 'package:flutter/material.dart';
void main ()=> runApp(const MaterialApp(home: SearchUser(),debugShowCheckedModeBanner: false,));
class SearchUser extends StatefulWidget {
  const SearchUser({super.key});
  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("Assets/1.jpg"),)
        ),
        child: Column(
          children: [
            const SizedBox(height: 80,),
            Center(
              child: Container(
                height: size.height/14,
                width: size.width-40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Search user",
                    suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.send_rounded,size: 25,),)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
