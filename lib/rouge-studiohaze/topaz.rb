# frozen_string_literal: true

require 'rouge'

module RougeStudioHaze
  class Topaz < Rouge::RegexLexer
    title 'Topaz'
    tag 'topaz'
    aliases 'tpz'
    filenames '*.tpz'
    desc 'Topaz (topaz.ooo)'

    state :root do
      rule /\s+/u, Text
      rule /\/\/[^\n]*/u, Comment::Single
      rule /\/\*/u, Comment::Multiline, :comment
      rule /(?:\b(?:p|r|sh|sql))?"""/u, Str::Double, :triple_string
      rule /(?:\b(?:p|r|sh|sql))?"/u, Str::Double, :string
      rule /0[xX][\da-fA-F](?:_?[\da-fA-F])*/u, Num::Hex
      rule /0[bB][01](?:_?[01])*/u, Num::Bin
      rule /\d(?:_?\d)*\.\d(?:_?\d)*/u, Num::Float
      rule /\d(?:_?\d)*/u, Num::Integer
      rule /(import|export|as)(?![\p{Letter}\p{Number}_\p{So}])/u, Keyword::Namespace
      rule /(let|mut|const|type|function|record|enum|newtype|protocol|impl|derives)(?![\p{Letter}\p{Number}_\p{So}])/u, Keyword::Declaration
      rule /(return|if|else|match|case|for|in|by|while|loop|break|continue|defer|using|concurrent)(?![\p{Letter}\p{Number}_\p{So}])/u, Keyword
      rule /(true|false|null|None)(?![\p{Letter}\p{Number}_\p{So}])/u, Keyword::Constant
      rule /(int|float|bool|string|template|Array|Map|Set|Option|Result|Eq|Order|Show|JSON)(?![\p{Letter}\p{Number}_\p{So}])/u, Keyword::Type
      rule /(Some|Ok|Err)(?![\p{Letter}\p{Number}_\p{So}])/u, Name::Builtin
      rule /[\p{Letter}_\p{So}][\p{Letter}\p{Number}_\p{So}]*/u, Name
      rule /->|=>|\.\.<|\.\.\.|\.\.|[+*\/%=!<>|&?^-]+/u, Operator
      rule /[{}()\[\],.:]/u, Punctuation
    end

    state :comment do
      rule /\*\//u, Comment::Multiline, :pop!
      rule /[^*]+/u, Comment::Multiline
      rule /\*/u, Comment::Multiline
    end

    state :string do
      rule /"/u, Str::Double, :pop!
      rule /\\[\s\S]/u, Str::Escape
      rule /\{/u, Str::Interpol, :interpolation
      rule /[^"\\{]+/u, Str::Double
    end

    state :triple_string do
      rule /"""/u, Str::Double, :pop!
      rule /\\[\s\S]/u, Str::Escape
      rule /\{/u, Str::Interpol, :interpolation
      rule /[^"\\{]+|"/u, Str::Double
    end

    state :interpolation do
      rule /\}/u, Str::Interpol, :pop!
      rule /\{/u, Punctuation, :interpolation
      mixin :root
    end

  end
end
