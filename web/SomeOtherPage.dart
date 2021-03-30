import 'dart:async';
import 'dart:html';

main(List<String> args) {
  Iterable<Map<String, dynamic>> x = [
    {'transform': 'translate(0%, 0%)'},
    {
      'transform':
          'translate(${window.screen.width - 50}px, ${window.screen.height - 50}px)'
    }
  ];
  querySelector('#move').animate(x, 5000);
  x = x.toList().reversed;
  Timer.periodic(Duration(seconds: 5), (t) {
    querySelector('#move').animate(x, 5000);
    x = x.toList().reversed;
  });
}
