String generateToken(String text) {
  final d = _codeList(text);

  int n = _t;

  for (int c in d) {
    n += c;
    n = _wrap(n, '+-a^+6');
  }

  n = _wrap(n, '+-3^+b+-f');
  n ^= _k;

  if (n < 0) n = (n & 2147483647) + 2147483648;

  n = (n % 1E6).round();

  return '$n.${n ^ _t}';
}

List<int> _codeList(String text) {
  final n = text.length;
  final codes = <int>[];

  for (int i = 0; i < n; i++) {
    int c = text.codeUnitAt(i);
    if (128 > c) {
      codes.add(c);
    } else {
      if (2048 > c) {
        codes.add(c >> 6 | 192);
      } else {
        if (55296 == (c & 64512) && (i + 1 < n) && 56320 == (text.codeUnitAt(i + 1) & 64512)) {
          c = 65536 + ((c & 1023) << 10) + (text.codeUnitAt(++i) & 1023);
          codes.add(c >> 18 | 240);
          codes.add(c >> 12 & 63 | 128);
        } else {
          codes.add(c >> 12 | 224);
        }
        codes.add(c >> 6 & 63 | 128);
      }
      codes.add(c & 63 | 128);
    }
  }

  return codes;
}

int _wrap(int a, String s) {
  int c, d;
  try {
    for (int i = 0; i < s.length - 2; i += 3) {
      c = s.codeUnitAt(i + 2);
      d = _a <= c ? c - 87 : int.parse(s[i + 2]);
      d = '+' == s[i + 1] ? _unsignedRightShift(a, d) : a << d;
      a = '+' == s[i] ? (a + d & 4294967295) : a ^ d;
    }
    return a;
  } on Error {
    rethrow;
  }
}

int _unsignedRightShift(int a, int b) {
  int m;
  if (b >= 32 || b < -32) {
    m = (b / 32) as int;
    b = b - (m * 32);
  }

  if (b < 0) {
    b = 32 + b;
  }

  if (b == 0) {
    return ((a >> 1) & 0x7fffffff) * 2 + ((a >> b) & 1);
  }

  if (a < 0) {
    a = (a >> 1);
    a &= 2147483647;
    a |= 0x40000000;
    a = (a >> (b - 1));
  } else {
    a = (a >> b);
  }
  return a;
}

final _a = 'a'.codeUnitAt(0);
const int _t = 406398;
const int _k = 561666268 + 1526272306;
