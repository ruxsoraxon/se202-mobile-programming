/// SE202 Mobile Programming — Lab 2, Exercise 2.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void main() {
  String? nickname;               // nullable
  String fullName = 'Ruxsoraxon'; // non-nullable
  print('Nickname: ${nickname ?? "no nickname"}');
  nickname ??= 'Ruxsi';
  print('Now: $nickname, full name: $fullName');
}
