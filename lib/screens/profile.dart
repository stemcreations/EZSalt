import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map profileData = {'street_address': 'null', 'distance': 'null', 'city': 'null',
  'last_name': 'null', 'zipcode': 0, 'phone_provider': '@vtext.com', 'depth': 0,
  'phone': 'null', 'sensor': 'null', 'state': 'null', 'first_name': 'null', 'email': 'null'};

  void getProfileData() async {
    profileData = await AuthService().getProfile();
    setState(() {});
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              child: Icon(Icons.edit),
              onTap: (){
              },
            ),
          )
        ],
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text('EZSalt', style: TextStyle(
                  fontFamily: 'EZSalt',
                  color: borderAndTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900
                ),),
              ),
              CustomProfileCard(cardData: profileData['first_name'] + ' ' + profileData['last_name'], icon: Icon(Icons.person, color: Colors.grey.shade600,),),
              TwoLineCustomCard(icon: Icons.location_on, firstLine: profileData['street_address'], secondLine: profileData['city'] + ' ' + profileData['state'] + ', ' + profileData['zipcode'].toString(),),
              CustomProfileCard(cardData: profileData['email'], icon: Icon(Icons.email, color: Colors.grey.shade600,),),
              TwoLineCustomCard(icon: Icons.phone, firstLine: profileData['phone'], secondLine: phoneCarriersReversed[profileData['phone_provider']],),
              CustomProfileCard(cardData: 'Tank Depth: ' + profileData['depth'].toString() + 'cm', icon: Icon(Icons.delete_outline, color: Colors.grey.shade600,),),
              CustomProfileCard(cardData: profileData['sensor'], icon: Icon(Icons.developer_board, color: Colors.grey.shade600,),),
            ],
          ),
        ),
      ),
    );
  }
}

class TwoLineCustomCard extends StatelessWidget {
  TwoLineCustomCard({this.firstLine, this.secondLine, this.icon});

  final String firstLine;
  final String secondLine;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(children: [
      Row(children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 35, bottom: 35, right: 10),
          child: Icon(icon, color: Colors.grey.shade600,),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  child: VerticalDivider(color: Colors.black, thickness: .6,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(firstLine, style: TextStyle(color: Colors.grey.shade600, fontSize: 16),),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  child: VerticalDivider(color: Colors.black, thickness: .6,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(secondLine, style: TextStyle(color: Colors.grey.shade600, fontSize: 16),),
                ),
              ],
            ),
          ],
        ),
        ],
      ),
        ],
      ),
    );
  }
}


class CustomProfileCard extends StatelessWidget {
  CustomProfileCard({@required this.cardData, this.icon});

  final String cardData;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20, right: 10),
            child: icon,
          ),
          Container(
            height: 50,
            child: VerticalDivider(color: Colors.black, thickness: .6,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(cardData, style: TextStyle(color: Colors.grey.shade600, fontSize: 16),),
          ),
        ],
      ),
    );
  }
}
