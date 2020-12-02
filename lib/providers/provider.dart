import 'package:flutter/material.dart';
class Provider extends InheritedWidget {
  static Provider _instance;
  //final _authBloc = new AuthBloc();
  //final _clubsBloc = new ClubsBloc();
  //final _userBloc = new UserBloc();
  //final _prestacionBloc = new PrestacionBloc();
  //final _reservationBloc = new ReservationBloc();
  //final _solicitudBloc = new SolicitudBloc();

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

 // static AuthBloc authBloc(BuildContext context) {
 //   return (context.inheritFromWidgetOfExactType(Provider) as Provider)
 //       ._authBloc;
 // }
//
 // static ClubsBloc clubsBloc(BuildContext context) {
 //   return (context.inheritFromWidgetOfExactType(Provider) as Provider)
 //       ._clubsBloc;
 // }
//
 // static UserBloc userBloc(BuildContext context) {
 //   return (context.inheritFromWidgetOfExactType(Provider) as Provider)
 //       ._userBloc;
 // }
//
 // static ReservationBloc reservationBloc(BuildContext context) {
 //   return (context.inheritFromWidgetOfExactType(Provider) as Provider)
 //       ._reservationBloc;
 // }
//
 // static PrestacionBloc prestacionBloc(BuildContext context) {
 //   return (context.inheritFromWidgetOfExactType(Provider) as Provider)
 //       ._prestacionBloc;
 // }
//
 // static SolicitudBloc solicitudBloc(BuildContext context) {
 //   return (context.inheritFromWidgetOfExactType(Provider) as Provider)
 //       ._solicitudBloc;
 // }
}
