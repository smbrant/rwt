# 
# Ext::Dict tests
# 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class Tx<Ext::Dict #redefining prologue/epilogue
  def prologue
    "pro"
  end
  def epilogue
    "epi"
  end
end

class TestDict < Test::Unit::TestCase

  def test_dict01
    a=Ext::Dict.new({:test1=>'test1',:test2=>'test2'})
    assert(a.render.include?("test1:'test1'") & a.render.include?("test2:'test2'") , 'Ext::Dict deve retornar apenas a lista de parametros')
    #flunk "TODO: Write test"
    # assert_equal("foo", bar)
  end

  def test_dict02
    a=Ext::Dict.new()
    assert(a.render =='{}', 'An empty dictionary')
  end

  def test_bloco_codigo
    a=Ext::Dict.new({}) do |b|
      b << {:par1=>'par1'}
      b << {:par2=>'par2',:par3=>'par3'}
    end
    assert(a.render.include?("par1:'par1'") & a.render.include?("par2:'par2'") & a.render.include?("par3:'par3'"),
      'Deve permitir acrescentar parametros em bloco de codigo no new')
    b=a.render do |dict|
      dict << {:par22=>'par22'}
    end
    assert(b.include?("par1:'par1'") & b.include?("par22:'par22'"), 'Deve permitir acrescentar parametros em bloco de codigo no render')
  end

  def test_prologue_epilogue
    a=Tx.new
    assert(a.render == 'proepi', "Redefinição de prologue/epilogue")
    b= a.render do |dict|
      dict << {:par1=>'par1'}
    end
    assert(b=="propar1:'par1'epi")
  end
  
  def test_not_string
    a=Ext::Dict.new({:number=>22,:boolean=>true})
    assert(a.render.include?('number:22') & a.render.include?('boolean:true'),"If not string return values without quotes")
  end
  
  def test_missing_method
    a=Ext::Dict.new(:first=>'first',:second=>'second')
    assert( a.first == 'first' &&  a.second == 'second','Convert missing methods to corresponding attribute values')
  end
  
end
