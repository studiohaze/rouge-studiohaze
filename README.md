# Rouge support for Topaz and Lispex

An external Rouge plug-in maintained by STUDIO HAZE. This package is independent
of Rouge core and is not an upstream-endorsed integration. It supports Topaz
(`.tpz`, `topaz`) and Lispex (`.lspx`, `lispex`).

## Use

Install directly from this repository with Bundler:

```ruby
gem 'rouge-studiohaze', git: 'https://github.com/studiohaze/rouge-studiohaze'
```

Then load the plug-in before highlighting:

```ruby
require 'rouge-studiohaze'
lexer = Rouge::Lexer.find('lispex')
html = Rouge::Formatters::HTML.new.format(lexer.lex('(define x 1/3)'))
```

In Jekyll, require this plug-in from a file under `_plugins/`. GitHub Pages'
restricted hosted build does not load arbitrary plug-ins; use a build environment
that permits loading the package. No RubyGems publication is claimed.

The lexers handle Topaz ordinary/triple strings, interpolation, Unicode names
and non-nesting comments, and Lispex exact rationals, character literals and
arbitrarily nested block comments. Highlighting does not validate programs or
provide compiler/reader rejection parity. No code execution is performed.

## Public references and tests

- [Topaz documentation](https://topaz.ooo/), [public release sources](https://github.com/studiohaze/topaz)
- [Lispex documentation](https://www.lispex.com/)
- [Rouge plug-in policy](https://codeberg.org/rouge-ruby/rouge/src/branch/master/CONTRIBUTING.md)
- [Rouge plug-in example](https://codeberg.org/rouge-ruby/rouge-plugin-example)

The complete example fixtures were executed with official Topaz 5.21.0
(`--compiler rust`) and Lispex 1.21.1 CLIs. Tests check filename/tag lookup,
lossless tokenization, no error tokens and independently specified token kinds.

```sh
gem install rouge -v 5.1.0 --no-document
gem install minitest -v 5.25.5 --no-document
ruby -Ilib test/languages_test.rb
gem build rouge-studiohaze.gemspec
```

This plug-in was prepared with AI assistance. Rouge's policy allows independently
published plug-ins while prohibiting LLM contributions to core. No core issue,
pull request or comment is part of this package.

MIT licensed. Only new lexer code and public example programs are included.
