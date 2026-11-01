# frozen_string_literal: true

require 'minitest/autorun'
require 'rouge-studiohaze'

class LanguagesTest < Minitest::Test
  def tokens(lexer, source)
    result = lexer.lex(source).to_a
    assert_equal source, result.map(&:last).join
    refute result.any? { |token, _| token.qualname == 'Error' }
    result
  end

  def assert_token(result, value, type)
    assert result.any? { |token, text| text == value && token.qualname == type },
           "missing #{type} token #{value.inspect}: #{result.inspect}"
  end

  def test_topaz_lookup
    assert_equal RougeStudioHaze::Topaz, Rouge::Lexer.find('topaz')
    assert_equal RougeStudioHaze::Topaz, Rouge::Lexer.guess(filename: 'sample.tpz')
  end

  def test_topaz_521_keywords_collection_heads_and_markup
    source = File.read(File.join(__dir__, 'fixtures/keywords-521.tpz'), encoding: 'UTF-8')
    result = tokens(RougeStudioHaze::Topaz.new, source)
    words = %w[let mut const type function return if else match case for in by while
               break continue defer concurrent true false null import export as record
               enum newtype protocol impl derives loop using]
    words.each do |word|
      assert result.any? { |kind, value| kind.qualname.start_with?('Keyword') && value == word }, word
    end
    %w[map set].each do |word|
      assert_equal 3, result.count { |kind, value| kind.qualname == 'Keyword' && value == word }
    end
    assert_equal 3, result.count { |kind, value| kind.qualname == 'Name' && value == 'map' }
    assert_token result, 'set', 'Name'
    %w[mapValue setValue map상태 set💎].each { |name| assert_token result, name, 'Name' }
    html = Rouge::Formatters::HTML.new.format(result)
    assert_equal File.read(File.join(__dir__, 'fixtures/keywords-521.expect.html'), encoding: 'UTF-8'), html
  end

  def test_lispex_lookup
    assert_equal RougeStudioHaze::Lispex, Rouge::Lexer.find('lispex')
    assert_equal RougeStudioHaze::Lispex, Rouge::Lexer.guess(filename: 'sample.lspx')
  end

  def test_topaz_boundaries
    source = "let let💎: int = 0x2A\nlet binary = 0b10_10\nlet text = \"Hi {let💎}\"\n/* outer /* inner */ let done = true\n"
    result = tokens(RougeStudioHaze::Topaz.new, source)
    assert_token result, 'let', 'Keyword.Declaration'
    assert_token result, 'let💎', 'Name'
    assert_token result, '0x2A', 'Literal.Number.Hex'
    assert_token result, '0b10_10', 'Literal.Number.Bin'
    assert_token result, 'done', 'Name'
    assert_token result, 'true', 'Keyword.Constant'
  end

  def test_topaz_triple_string
    result = tokens(RougeStudioHaze::Topaz.new, "let text = \"\"\"\n// string body\n\"\"\"\n")
    refute result.any? { |token, _| token.qualname.start_with?('Comment') }
  end

  def test_lispex_boundaries
    result = tokens(RougeStudioHaze::Lispex.new, "(define +5 1/3) #| outer #| inner |# end |#\n(list #\\\" #\\; #f \"text;\")\n")
    assert_token result, 'define', 'Keyword'
    assert_token result, '+5', 'Name.Variable'
    assert_token result, '1/3', 'Literal.Number'
    assert_token result, '#\\"', 'Literal.String.Char'
    assert_token result, '#\\;', 'Literal.String.Char'
    assert_token result, '#f', 'Name.Constant'
  end

  def test_lispex_deep_comments
    source = '#| ' * 100 + 'inside' + ' |#' * 100 + ' (define done #t)'
    result = tokens(RougeStudioHaze::Lispex.new, source)
    assert_token result, 'define', 'Keyword'
    assert_token result, '#t', 'Name.Constant'
    assert_equal 'Comment.Multiline', result.first.first.qualname
  end

  def test_complete_topaz
    tokens(RougeStudioHaze::Topaz.new, File.read(File.join(__dir__, 'fixtures/topaz.tpz'), encoding: 'UTF-8'))
  end

  def test_complete_lispex
    tokens(RougeStudioHaze::Lispex.new, File.read(File.join(__dir__, 'fixtures/lispex.lspx'), encoding: 'UTF-8'))
  end
end
