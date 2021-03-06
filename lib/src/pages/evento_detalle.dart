import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_modelo.dart';
import 'package:peliculas/src/models/evento_modelo.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

import 'package:peliculas/src/providers/datos_clima.dart';

class EventoDetalle extends StatelessWidget {
  // PeliculaDetalle(this.pelicula);
  @override
  Widget build(BuildContext context) {
    final Evento pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(pelicula),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(pelicula, context),
            _descripcion(pelicula),
            _crearCasting(pelicula)
          ]),
        )
      ],
    ));
  }

  Widget _datosMeteorologicos(BuildContext context) {
    return FutureBuilder(
      future: ClimaParam.obtenerDatos(),
      builder: (BuildContext context, AsyncSnapshot<Clima> snapshot) {
        if (snapshot.hasData) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Temperatura: " +
                    snapshot.data.temperatura.toString() +
                    " °F"),
                Text("Sensación: " + snapshot.data.feelslike.toString() + "°F"),
                Text("Humedad: " + snapshot.data.humedad.toString() + " g/m^3"),
              ]);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _crearAppbar(Evento pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 100),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Evento pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: NetworkImage(pelicula.getPosterImg()),
              height: 150.0,
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.title,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: <Widget>[Icon(Icons.star_border), Text("10")],
                ),
                _datosMeteorologicos(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Evento pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(pelicula.description, textAlign: TextAlign.justify),
    );
  }

  Widget _crearCasting(Evento pelicula) {
    final peliProvider = new PeliculasProvider();
    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(initialPage: 1, viewportFraction: 0.3),
        itemCount: actores.length,
        itemBuilder: (context, i) {
          return _actorTarjeta(actores[i]);
        },
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(actor.name)
        ],
      ),
    );
  }
}
