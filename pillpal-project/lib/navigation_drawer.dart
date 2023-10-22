import 'package:bloc/bloc.dart';

class NavigationDrawerCubit extends Cubit<bool> {
  NavigationDrawerCubit() : super(false); // Inicialmente, el cajón está cerrado.

  void toggleDrawer() {
    emit(!state); // Cambia el estado del cajón de abierto a cerrado o viceversa.
  }
}