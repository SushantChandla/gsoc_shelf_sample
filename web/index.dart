import 'dart:html';

main() {
  querySelector('#hello').innerHtml = 'I was changed with index.dart';
  querySelector('#hello').onClick.listen((event) {
    window.alert('onClick');
  });
  
}
