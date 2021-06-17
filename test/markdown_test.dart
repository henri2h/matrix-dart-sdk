/*
 *   Famedly Matrix SDK
 *   Copyright (C) 2019, 2020 Famedly GmbH
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of the
 *   License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:matrix/src/utils/markdown.dart';
import 'package:test/test.dart';

void main() {
  group('markdown', () {
    final emotePacks = {
      'room': {
        ':fox:': 'mxc://roomfox',
        ':bunny:': 'mxc://roombunny',
      },
      'user': {
        ':fox:': 'mxc://userfox',
        ':bunny:': 'mxc://userbunny',
        ':raccoon:': 'mxc://raccoon',
      },
    };
    test('simple markdown', () {
      expect(markdown('hey *there* how are **you** doing?'),
          'hey <em>there</em> how are <strong>you</strong> doing?');
      expect(markdown('wha ~~strike~~ works!'), 'wha <del>strike</del> works!');
    });
    test('spoilers', () {
      expect(markdown('Snape killed ||Dumbledoor||'),
          'Snape killed <span data-mx-spoiler="">Dumbledoor</span>');
      expect(markdown('Snape killed ||Story|Dumbledoor||'),
          'Snape killed <span data-mx-spoiler="Story">Dumbledoor</span>');
    });
    test('multiple paragraphs', () {
      expect(markdown('Heya!\n\nBeep'), '<p>Heya!</p>\n<p>Beep</p>');
    });
    test('Other block elements', () {
      expect(markdown('# blah\n\nblubb'), '<h1>blah</h1>\n<p>blubb</p>');
    });
    test('linebreaks', () {
      expect(markdown('foxies\ncute'), 'foxies<br />\ncute');
    });
    test('emotes', () {
      expect(markdown(':fox:', emotePacks),
          '<img data-mx-emoticon="" src="mxc://roomfox" alt=":fox:" title=":fox:" height="32" vertical-align="middle" />');
      expect(markdown(':user~fox:', emotePacks),
          '<img data-mx-emoticon="" src="mxc://userfox" alt=":fox:" title=":fox:" height="32" vertical-align="middle" />');
      expect(markdown(':raccoon:', emotePacks),
          '<img data-mx-emoticon="" src="mxc://raccoon" alt=":raccoon:" title=":raccoon:" height="32" vertical-align="middle" />');
      expect(markdown(':invalid:', emotePacks), ':invalid:');
      expect(markdown(':room~invalid:', emotePacks), ':room~invalid:');
    });
    test('pills', () {
      expect(markdown('Hey @sorunome:sorunome.de!'),
          'Hey <a href="https://matrix.to/#/@sorunome:sorunome.de">@sorunome:sorunome.de</a>!');
      expect(markdown('#fox:sorunome.de: you all are awesome'),
          '<a href="https://matrix.to/#/#fox:sorunome.de">#fox:sorunome.de</a>: you all are awesome');
      expect(markdown('!blah:example.org'),
          '<a href="https://matrix.to/#/!blah:example.org">!blah:example.org</a>');
      expect(markdown('https://matrix.to/#/#fox:sorunome.de'),
          'https://matrix.to/#/#fox:sorunome.de');
    });
    test('latex', () {
      expect(markdown('meep \$\\frac{2}{3}\$'),
          'meep <span data-mx-maths="\\frac{2}{3}"><code>\\frac{2}{3}</code></span>');
      expect(markdown('meep \$hmm *yay*\$'),
          'meep <span data-mx-maths="hmm *yay*"><code>hmm *yay*</code></span>');
      expect(markdown('you have \$somevar and \$someothervar'),
          'you have \$somevar and \$someothervar');
      expect(markdown('meep ||\$\\frac{2}{3}\$||'),
          'meep <span data-mx-spoiler=""><span data-mx-maths="\\frac{2}{3}"><code>\\frac{2}{3}</code></span></span>');
      expect(markdown('meep `\$\\frac{2}{3}\$`'),
          'meep <code>\$\\frac{2}{3}\$</code>');
      expect(markdown('hey\n\$\$beep\$\$\nmeow'),
          '<p>hey</p>\n<div data-mx-maths="beep">\n<pre><code>beep</code></pre>\n</div>\n<p>meow</p>');
      expect(markdown('hey\n\$\$\nbeep\nboop\n\$\$\nmeow'),
          '<p>hey</p>\n<div data-mx-maths="beep\nboop">\n<pre><code>beep\nboop</code></pre>\n</div>\n<p>meow</p>');
    });
  });
}
