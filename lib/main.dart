import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';  

void main() {
  PaintingBinding.instance?.imageCache?.maximumSizeBytes = 5 << 20; // 5 MB
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  bool imageVisible = false;
  int counter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  void updateState_works_fine() {
    setState(() {
      if (counter == 0) {
        print(">>>>>>> precache image ");
        precacheImage(AssetImage("assets/images/background_image.png"), context);
      }

      if (counter == 1) {
        print(">>>>>>> show image ");
        imageVisible = true;
      }

      if (counter == 2) {
        print(">>>>>>> clear cache ");
        imageCache?.clear();
      }

      if (counter == 3) {
        print(">>>>>>> set imageVisible to false");
        imageVisible = false;
      }

      counter++;
    });
  }

  void updateState() {
    setState(() {
      if (counter == 0) {
        print(">>>>>>> precache image ");
        precacheImage(AssetImage("assets/images/background_image.png"), context);

        //This delayed call try to emulates the imageCache.clear request that can be triggered by
        //FlutterEngineNotifyLowMemoryWarning callback.
        Future.delayed(const Duration(milliseconds: 10), () {
          print(">>>>>>> clear cache ");
          imageCache?.clear();
        });
      }

      if (counter == 1) {
        print(">>>>>>> show image ");
        imageVisible = true;
      }

      if (counter == 2) {
        print(">>>>>>> set imageVisible to false");
        imageVisible = false;
      }

      if (counter >= 3) {
        print(">>>>>>> clear cache ");
        imageCache?.clear();
      }


      counter++;
    });
  }

    @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  imageVisible ? 
                    Image.asset(
                      'assets/images/background_image.png',
                      width: 600.0,
                      height: 240.0,
                      fit: BoxFit.cover,
                    ) 
                    :  
                    Container(
                      height: 200,
                      width: 200,
                      color: Colors.red,
                    ),
                ]
            ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: updateState,
            child: Icon(Icons.add),
        ),
    );
  }
}
