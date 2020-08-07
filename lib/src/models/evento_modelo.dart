class Eventos {
  List<Evento> items = new List();
  Eventos();

  Eventos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final evento = new Evento.fromJsonMap(item);
      items.add(evento);
    }
  }
}

class Evento {
  var _posterURL = r"https://rhapsodic-hairpin.000webhostapp.com/";
  static String dir = r'https://appeventossu.herokuapp.com/';
  String id;
  String title;
  String description;
  String posterPath;
  String uniqueID;
  Evento({
    this.id,
    this.title,
    this.description,
    this.posterPath,
  });

  Evento.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'].toString();
    posterPath = json['portada'];
    description = json['descripcion'];
    title = json['titulo'];
  }

  getPosterImg() {
    if (posterPath == null) {
      return 'https://us.123rf.com/450wm/novintito/novintito1204/novintito120400157/13269109-sala-vac%C3%ADa-con-fondo-oscuro.jpg?ver=6';
    }
    return _posterURL + posterPath;
  }

  getBackgroundImg() {
    if (posterPath == null) {
      return 'https://us.123rf.com/450wm/novintito/novintito1204/novintito120400157/13269109-sala-vac%C3%ADa-con-fondo-oscuro.jpg?ver=6';
    }
    return _posterURL +
        'vistas/img/cabeceras/entradas-conferencia-magistral.jpg';
  }
}
