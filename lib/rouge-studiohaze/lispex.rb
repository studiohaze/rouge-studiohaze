# frozen_string_literal: true

require 'rouge'

module RougeStudioHaze
  class Lispex < Rouge::RegexLexer
    title 'Lispex'
    tag 'lispex'
    aliases 'lspx'
    filenames '*.lspx'
    desc 'Lispex (www.lispex.com)'

    state :root do
      rule /\s+/u, Text
      rule /;[^\n]*/u, Comment::Single
      rule /#\|/u, Comment::Multiline, :comment
      rule /#\\(?:x[\da-fA-F]+|[A-Za-z]+|[^\s])/u, Str::Char
      rule /"/u, Str::Double, :string
      rule /#(?:true|false|t|f)(?=\z|[\s()'`,;"])/u, Name::Constant
      rule /-?(?:0|[1-9]\d*)\/[1-9]\d*(?=\z|[\s()'`,;"])/u, Num
      rule /-?(?:0|[1-9]\d*)(?:\.\d+(?:[eE][-+]?\d+)?|[eE][-+]?\d+)(?=\z|[\s()'`,;"])/u, Num::Float
      rule /-?(?:0|[1-9]\d*)(?=\z|[\s()'`,;"])/u, Num::Integer
      rule /(quote|quasiquote|unquote|unquote-splicing|lambda|if|begin|set!|define|let|let\*|letrec|cond|case|guard|and|or|when|unless|do|module|export|import)(?=\z|[\s()'`,;"])/u, Keyword
      rule /(values|call-with-values|call\/cc|dynamic-wind|cons|car|cdr|list|map|apply|error|error-object\?|error-object-message|number\?|string\?|boolean\?|pair\?|null\?|vector|vector-ref|bytevector-u8-ref|display|newline|\+|-|\*|\/|=|<|>|<=|>=)(?=\z|[\s()'`,;"])/u, Name::Builtin
      rule /'[\p{Letter}_][^\s()'`,;"#]*/u, Str::Symbol
      rule /#(?:u8)?\(/u, Punctuation
      rule /,@|['`,]/u, Operator
      rule /[^\s()'`,;"#]+/u, Name::Variable
      rule /[()]/u, Punctuation
    end

    state :comment do
      rule /#\|/u, Comment::Multiline, :comment
      rule /\|#/u, Comment::Multiline, :pop!
      rule /[^#|]+|[#|]/u, Comment::Multiline
    end

    state :string do
      rule /"/u, Str::Double, :pop!
      rule /\\(?:["\\ntr]|x[\da-fA-F]+;)/u, Str::Escape
      rule /[^"\\]+/u, Str::Double
    end

  end
end
