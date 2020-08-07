import 'package:flutter/material.dart';
import 'package:peliculas/src/models/evento_modelo.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Evento> peliculas;
  final Function siguientePagina;
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});
  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
      if (_pageController.position.pixels <=
          _pageController.position.minScrollExtent + 100) {
        _pageController.position.correctPixels(100.0);
      }
    });

    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, i) =>
            _tarjeta(context, peliculas[i], _screenSize.height),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Evento pelicula, double _screeSize) {
    pelicula.uniqueID = '${pelicula.id}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(pelicula.getPosterImg()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              fit: BoxFit.cover,
              height: _screeSize * 0.2,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'evento', arguments: pelicula);
      },
    );
  }

  List<Widget> _targetas(double _screeSize, BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: _screeSize * 0.2,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
