import 'package:flutter/material.dart';
import 'package:foto_share_app/content/agregar/agregar.dart';
import 'package:foto_share_app/content/espera/en_espera.dart';
import 'package:foto_share_app/content/foru/fotos_for_you.dart';
import 'package:foto_share_app/content/mis_fotos/mi_contenido.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  var _pagesList = [
    FotosForYou(),
    EnEspera(),
    MiContenido(),
    Agregar(),
  ];
  var _pagesNameList = ["Fotos 4U", "En espera", "Mi Contenido", "Nuevo"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${_pagesNameList[_currentIndex]}"),
        ),
        body: IndexedStack(children: _pagesList, index: _currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 54, 216, 244),
          currentIndex: _currentIndex,
          onTap: (selectItem) {
            _currentIndex = selectItem;
            setState(() {});
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                label: _pagesNameList[0],
                icon: Icon(
                  Icons.view_carousel,
                )),
            BottomNavigationBarItem(
                label: _pagesNameList[1], icon: Icon(Icons.query_builder)),
            BottomNavigationBarItem(
                label: _pagesNameList[2], icon: Icon(Icons.photo_camera)),
            BottomNavigationBarItem(
                label: _pagesNameList[3], icon: Icon(Icons.mobile_friendly)),
          ],
        ));
  }
}
