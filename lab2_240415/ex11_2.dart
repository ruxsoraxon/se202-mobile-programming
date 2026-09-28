/// SE202 Mobile Programming — Lab 2, Exercise 11.2
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

Future<Map<String, String>> findUser(int id) async {
  await Future.delayed(const Duration(seconds: 2));
  return {'id': '$id', 'name': 'User$id'};
}

Future<void> main() async {
  print('Looking up user...');
  print(await findUser(7));
}
