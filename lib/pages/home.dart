import 'package:camera/camera.dart';
import 'package:face_reconocimiento_app/pages/db/database.dart';
import 'package:face_reconocimiento_app/pages/login.dart';
import 'package:face_reconocimiento_app/pages/registro.dart';
import 'package:face_reconocimiento_app/responsive.dart';
import 'package:face_reconocimiento_app/services/facenet_service.dart';
import 'package:face_reconocimiento_app/services/ml_vision_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlVisionService.initialize();

    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: !loading
          ? Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image(
                    image: AssetImage('assets/fondoChiki.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 20,
                  right: -200,
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://pbs.twimg.com/media/DuQ4ezJWkAAiyuR.jpg'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: -10,
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://blackversions.b-cdn.net/wp-content/uploads/2020/02/Noticia-263543-susy-696x448.png'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 0,
                  right: 220,
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://cde.americatv.com.pe/el-gran-show-luis-cuto-guadalupe-todo-lo-que-paso-gran-show-fue-maravilloso-noticia-60404-696x418-163562.jpg'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 10,
                  right: 10,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Borrar BD'),
                          onPressed: () {
                            _dataBaseService.cleanDB();
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FlatButton(
                            child: Text(
                              'Ingresar',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SignIn(
                                    cameraDescription: cameraDescription,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: responsive.wp(60),
                            child: Text(
                              'Face Unap ',
                              style: GoogleFonts.comicNeue(
                                textStyle: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 90,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              width: responsive.wp(30),
                              child: Image(
                                image: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSDJUeOVmULcrbIOWKvIqSIcgzUzgDOOXQWqg&usqp=CAU'),
                              ))
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FlatButton(
                          child: Text(
                            'Regístrese',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignUp(
                                  cameraDescription: cameraDescription,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
