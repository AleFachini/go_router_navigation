import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  static const title = 'GoRouter Example: Custom Error Screen';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: title,
      );

  final _router = GoRouter(
    initialLocation: '/page3',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Page1Screen(),
      ),
      GoRoute(
        path: '/page2',
        builder: (context, state) => const Page2Screen(),
        routes: [
          GoRoute(
            path: 'family/:fid',
            builder: (context, state) => FamilyScreen(
              family: Families.family(state.params['fid']!),
            ),
            routes: [
              GoRoute(
                path: 'person/:pid',
                builder: (context, state) {
                  final family = Families.family(state.params['fid']!);
                  final person = family.person(state.params['pid']!);

                  return PersonScreen(family: family, person: person);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/page3',
        builder: (context, state) => const Page3Screen(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(state.error!),
  );
}

class Page1Screen extends StatelessWidget {
  const Page1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/page2'),
                child: const Text('Go to page 2'),
              ),
            ],
          ),
        ),
      );
}

class Page2Screen extends StatelessWidget {
  const Page2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to home page'),
              ),
            ],
          ),
        ),
      );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.error, {Key? key}) : super(key: key);
  final Exception error;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('My "Page Not Found" Screen')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText(error.toString()),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Home'),
              ),
            ],
          ),
        ),
      );
}

class Page3Screen extends StatelessWidget {
  const Page3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/page2'),
                child: const Text('Go to page 2'),
              ),
            ],
          ),
        ),
      );
}

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({required this.family, Key? key}) : super(key: key);
  final Family family;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(family.name)),
    body: ListView(
      children: [
        for (final p in family.people)
          ListTile(
            title: Text(p.name),
            onTap: () => context.go('/family/${family.id}/person/${p.id}'),
          ),
      ],
    ),
  );
}

class PersonScreen extends StatelessWidget {
  const PersonScreen({required this.family, required this.person, Key? key})
      : super(key: key);

  final Family family;
  final Person person;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text(person.name)),
        body: Text('${person.name} ${family.name} is ${person.age} years old'),
      );

}

class Person {
  Person({required this.id, required this.name, required this.age});

  final String id;
  final String name;
  final int age;
}

class Family {
  Family({required this.id, required this.name, required this.people});

  final String id;
  final String name;
  final List<Person> people;

  Person person(String pid) => people.singleWhere(
        (p) => p.id == pid,
    orElse: () => throw Exception('unknown person $pid for family $id'),
  );
}

class Families {
  static final data = [
    Family(
      id: 'f1',
      name: 'Sells',
      people: [
        Person(id: 'p1', name: 'Chris', age: 52),
        Person(id: 'p2', name: 'John', age: 27),
        Person(id: 'p3', name: 'Tom', age: 26),
      ],
    ),
    Family(
      id: 'f2',
      name: 'Addams',
      people: [
        Person(id: 'p1', name: 'Gomez', age: 55),
        Person(id: 'p2', name: 'Morticia', age: 50),
        Person(id: 'p3', name: 'Pugsley', age: 10),
        Person(id: 'p4', name: 'Wednesday', age: 17),
      ],
    ),
    Family(
      id: 'f3',
      name: 'Hunting',
      people: [
        Person(id: 'p1', name: 'Mom', age: 54),
        Person(id: 'p2', name: 'Dad', age: 55),
        Person(id: 'p3', name: 'Will', age: 20),
        Person(id: 'p4', name: 'Marky', age: 21),
        Person(id: 'p5', name: 'Ricky', age: 22),
        Person(id: 'p6', name: 'Danny', age: 23),
        Person(id: 'p7', name: 'Terry', age: 24),
        Person(id: 'p8', name: 'Mikey', age: 25),
        Person(id: 'p9', name: 'Davey', age: 26),
        Person(id: 'p10', name: 'Timmy', age: 27),
        Person(id: 'p11', name: 'Tommy', age: 28),
        Person(id: 'p12', name: 'Joey', age: 29),
        Person(id: 'p13', name: 'Robby', age: 30),
        Person(id: 'p14', name: 'Johnny', age: 31),
        Person(id: 'p15', name: 'Brian', age: 32),
      ],
    ),
  ];

  static Family family(String fid) => data.family(fid);
}

extension on List<Family> {
  Family family(String fid) => singleWhere(
        (f) => f.id == fid,
    orElse: () => throw Exception('unknown family $fid'),
  );
}
