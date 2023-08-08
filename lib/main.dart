import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Eventos 
abstract class AuthEvent {}

class LoginButtonPressed extends AuthEvent {
  final String username;
  final String password;

  LoginButtonPressed({required this.username, required this.password});
}

// Estado 
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthFailureState extends AuthState {
  final String error;

  AuthFailureState({required this.error});
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginButtonPressed) {
      yield AuthLoadingState();

      // Aquí puedes agregar la lógica para validar el inicio de sesión con un backend o una base de datos.
      // Por simplicidad, aquí solo estamos simulando un inicio de sesión exitoso con los credenciales "admin" y "password".
      await Future.delayed(Duration(seconds: 2));

      if (event.username == "admin" && event.password == "password") {
        yield AuthSuccessState();
      } else {
        yield AuthFailureState(error: "Credenciales incorrectas");
      }
    }
  }
}

// Pantalla de inicio de sesión
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('W&G Seguros Generales'),
      ),
      backgroundColor: Color.fromARGB(255, 221, 231, 192),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              // Navegar a la siguiente pantalla después de un inicio de sesión exitoso.
              Navigator.pushReplacementNamed(context, '/home');
            }
            if (state is AuthFailureState) {
              // Mostrar un diálogo o un mensaje de error en caso de fallo.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text(state.error),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              // Mostrar un indicador de carga mientras se verifica el inicio de sesión.
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // Mostrar el formulario de inicio de sesión si no está cargando.
              return LoginForm();
            }
          },
        ),
      ),
    );
  }
}

// Formulario de inicio de sesión
class LoginForm extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              _authBloc.add(
                LoginButtonPressed(
                  username: _usernameController.text,
                  password: _passwordController.text,
                ),
              );
            },
            child: Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
    routes: {
      '/home': (context) => HomeScreen(),
    },
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pantalla de inicio'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Navegar de vuelta a la pantalla de inicio de sesión al presionar el botón "Salir"
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
        body: cuerpo()
        // Center(child: Text('¡Inicio de sesión exitoso!'),

        );
  }
}

Widget cuerpo() {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.red.shade200),
                child: Center(
                  child: Text(
                    'Contenido 1',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.yellow.shade200),
                child: Center(
                  child: Text(
                    'Contenido 2',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://st2.depositphotos.com/1787005/7298/i/450/depositphotos_72987231-stock-photo-lochernhead-scotland.jpg'),
                  fit: BoxFit.cover)),
          child: Center(
              child: Text(
            '¡Inicio sesion correctamente!',
            style: TextStyle(color: Colors.black, fontSize: 30.0),
          )),
        ),
      ],
    ),
  );
}
