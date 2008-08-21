# 
# Ext::List tests
# 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext/list'

class Txl<Ext::List #redefining prologue/epilogue
  def prologue
    "pro"
  end
  def epilogue
    "epi"
  end
end

class TestList < Test::Unit::TestCase

  def test_list01
    a=Ext::List.new(['test1','test2'])
    assert(a.render==a.prologue+"'test1','test2'"+a.epilogue , 'Ext::List deve retornar apenas a lista de parametros')
    #flunk "TODO: Write test"
    # assert_equal("foo", bar)
  end

  def test_list02
    a=Ext::List.new()
    assert(a.render =='[]', 'An empty list')
  end

  def test_bloco_codigo
    a=Ext::List.new([]) do |b|
      b << ['par1']
      b << ['par2','par3']
    end
    assert(a.render.include?("'par1'") & a.render.include?("'par2'") & a.render.include?("'par3'"),
      'Deve permitir acrescentar parametros em bloco de codigo no new')
    b=a.render do |dict|
      dict << ['par22']
    end
    assert(b==a.prologue+"'par1','par2','par3','par22'"+a.epilogue, 'Deve permitir acrescentar parametros em bloco de codigo no render')
  end

  def test_prologue_epilogue
    a=Txl.new
    assert(a.render == 'proepi', "Redefinição de prologue/epilogue")
    b= a.render do |dict|
      dict << ['par1']
    end
    assert(b=="pro'par1'epi")
  end
  
  def test_not_string
    a=Ext::List.new([22,true])
    assert(a.render==a.prologue+'22,true'+a.epilogue,"If not string return values without quotes")
  end

end
