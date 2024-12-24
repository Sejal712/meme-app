import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memeapp/controller/fatchMeme.dart';
import 'package:memeapp/controller/saveMyData.dart';
import 'package:http/http.dart' as http;

class homeScreen extends StatefulWidget {
  homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  String imgUrl="";
  int? memeNo;
  int targetMeme=100;
  bool isLoading=true;
  bool isbtnDisable=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetInitMemeNo();
    updateImg();
  }



  GetInitMemeNo() async
  {
    memeNo=await SaveMyData.fetchData() ?? 0;
    if(memeNo! > 100)
    {
      targetMeme=500;
    }
    else if(memeNo! >500)
    {
      targetMeme=1000;
    }
    setState(() { });
  }

  void updateImg ()async
  {
    try {
      setState(() {
        isLoading = true;
        isbtnDisable = true;
      });
      String getimgUrl = await FetchMeme.fetchNewMeme();
      final response = await http.head(Uri.parse(getimgUrl));
      if (response.statusCode == 200) {
        setState(() {
          imgUrl = getimgUrl;
          isLoading = false;
          isbtnDisable = false;
        });
      }
      else
      {
        throw Exception("Invalid URL: ${response.statusCode}");
      }
    }
    catch(error)
    {
      setState(() {
        isLoading = false;
        isbtnDisable = false; // Re-enable the button even if there's an error
        imgUrl = ""; // Optionally set a placeholder image here
      });
      print("Error loading image: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            SizedBox(height: 120,),
            Text("Meme #${memeNo}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),

            SizedBox(height: 10,),
            Text("Target ${targetMeme} Memes",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),

            SizedBox(height: 30,),

            isLoading ?

            Container(
              height:300,
              width:MediaQuery.of(context).size.width,
              child: Center(
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator()),
              )
              ,):

            Image.network(
                height:300,fit:BoxFit.fitHeight,
                width:MediaQuery.of(context).size.width,imgUrl),

            SizedBox(height: 20,),

            Container(width:150,height:50,
                child: ElevatedButton(onPressed:isbtnDisable
                    ?null: ()async{
                  setState(() {
                    isLoading=true;
                  });
                  await SaveMyData.saveData(memeNo!+1);

                  updateImg();
                  GetInitMemeNo();
                }, child: Center(child: Text("More Fun",style: TextStyle(fontSize: 20),)))),

            Spacer(),

            Text("APP CREATED BY",style: TextStyle(fontSize: 20),),

            Text("Sejal Lathigara",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}