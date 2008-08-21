require 'test/unit'
require 'rwt/component'

class TestComponent < Test::Unit::TestCase
  def test_basic
    c= Rwt::Component.new(:p1=>'p1',:p2=>'p2')
#    c.config.each do |key,value|
#      puts ":#{key}=>#{value}"
#    end
   assert(c.config[:p1]=='p1' && c.config[:p2]=='p2'&&c.config[:id]=='rwt_1', 'Error in configuration values.')
  end
  
  def test_block
    c= Rwt::Component.new(:p1=>'p1',:p2=>'p2') do |parent|
      child = Rwt::Component.new(:pchild1=>'pchild1')
      parent << child                                     #child1
      parent << Rwt::Component.new(:pchild2=>'pchild2')   #child2
    end
    assert(c.components[0].config[:pchild1]=='pchild1' && c.components[1].config[:pchild2]=='pchild2',
        'Error in child added in a block.')
  end

  def test_block_inside_block
    nchildren=0
    children=''
    big= Rwt::Component.new(:grandparent=>'grandparent') do |gp|
      gp << Rwt::Component.new(:parent=>'parent') do |p|
        p << Rwt::Component.new(:child=>'child1') do |c|
          nchildren+=1
          children<<c.config[:child]
        end
        p << Rwt::Component.new(:child=>'child2') do |c|
          nchildren+=1
          children<<c.config[:child]
        end
      end
    end
    assert(big.components[0].components[1].config[:child]=='child2',
        'Error in child added in a block.')
    assert(nchildren==2,'Wrong number of children created.')
    assert(children=='child1child2','Wrong child stored config.')
  end
  
  def test_program
    comp=Rwt::Component.new
    a= comp.program('test1','test2').render
    assert(a=='(function(cmp){test1;test2;})','Different generated javascript.')
  end
end
