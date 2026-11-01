# Topaz and Lispex for Rouge

A Rouge plugin for [Topaz](https://topaz.ooo/) and [Lispex](https://www.lispex.com/), from STUDIO HAZE. It registers `topaz` for `.tpz` files and `lispex` for `.lspx` files.

## Install

Add it to your Gemfile from this repository.

```ruby
gem 'rouge-studiohaze', git: 'https://github.com/studiohaze/rouge-studiohaze'
```

## Use

```ruby
require 'rouge-studiohaze'
lexer = Rouge::Lexer.find('lispex')
html = Rouge::Formatters::HTML.new.format(lexer.lex('(define x 1/3)'))
```

In Jekyll, require the plugin from a file under `_plugins/`. GitHub Pages runs a restricted build that doesn't load custom plugins, so build the site somewhere that does.

The Topaz lexer handles plain and triple-quoted strings, interpolation, Unicode names and comments. The Lispex lexer handles exact rationals, character literals and nested block comments at any depth.

## Develop

```sh
gem install rouge -v 5.1.0 --no-document
gem install minitest -v 5.25.5 --no-document
ruby -Ilib test/languages_test.rb
gem build rouge-studiohaze.gemspec
```

## Links

- [Topaz documentation](https://topaz.ooo/en/docs)
- [Topaz source](https://github.com/studiohaze/topaz)
- [Lispex documentation](https://www.lispex.com/en/docs)

## License

MIT
