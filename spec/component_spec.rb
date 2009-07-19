require 'rwt'
include Rwt

describe Rwt::Component do
  before(:each) do
    Rwt.clear
  end

  it "should generate javascript in the buffer" do
    component(:a_parameter=>'a_value')
    Rwt.code.should include("v:") # all components has a unique identification stored in the 'v' parameter
    Rwt.code.should include("a_parameter:'a_value'")
#   puts Rwt.code
  end

  it "should accept the :text parameter as the first non keyed value" do
    component('First Component')
    Rwt.code.should include("text:'First Component'")
    component(:a_parameter=>'a_value',:text=>'Second Component') # can use keyed form too
    Rwt.code.should include("text:'Second Component'")
#   puts Rwt.code
  end

  it "should ignore non-treated non-hashed parameters" do
    component('first','second','third')
    Rwt.code.should include("text:'first'")
    Rwt.code.should_not include("second")
    Rwt.code.should_not include("third")
#   puts Rwt.code
  end

  it "should pass non-treated hashed parameters 'as-is' to javascript" do
    component(:first=>'first',:second=>'second',:third=>'third')
    Rwt.code.should include("first:'first'")
    Rwt.code.should include("second:'second'")
    Rwt.code.should include("third:'third'")
#   puts Rwt.code
  end

  it "should accept code blocks and interpret then as hierachies of components" do
    component('father') do
      component('son1') do
        component('grandson1')
      end
      component('son2')
    end
#   puts Rwt.code
  end

  it "should be able to construct a hierachy of components and reference block variables" do
    a_gf=component('grandfather') do |gf| # gf here only needed because of reference in son
      component('father') do |f|
        f.owner.config[:text].should == 'grandfather'
        component('son') do |s|
          s.owner.config[:text].should == 'father'
        end
      end
    end
  end

  it "should return component internal id with to_s" do
    comp= component(:who=>'some_component')
    "#{comp}".should == comp.config[:v]
    comp.should.to_s == comp.config[:v]
  end

  # accessors:
  #  attr_reader :components  # owned components
  #  attr_reader :config      # configuration hash
  #  attr_reader :owner       # owner of component

  it "should give access to components, config and owner accessors" do
    component('one') do |one|
      c2= component('two') do |two|
        two.owner.should == one
      end
      c3= component('tree') do |tree|
        tree.owner.should == one
      end
      one.components[0].should == c2
      one.components[1].should == c3
      c2.config[:text].should == 'two'
      c3.config[:text].should == 'tree'
    end
  end

  it "can inject javascript directly in the buffer" do
    comp=component('A component')
    Rwt << "alert(#{comp}.text);"
#    puts Rwt.code
    Rwt.code.should include("alert(#{comp}.text);")
  end

  # Mixing ruby and javascript (necessary in some cases...)
  it "should have sons 'seeing' fathers in javascript" do
    father=component(:who=>'father') do |f|
      component(:who=>'son',
        :handler=>function("#{f}.close()")  # e.g., a son that closes the father...
      )
    end
#    puts Rwt.code
    Rwt.code.should include("function(){#{father}.close()}")
  end

  # Events in ruby stores code blocks that generates javascript code during the rendering...
  it "should process the 'on' method call as event definition" do
    c1=component('one') do |one|
      one.on('close') do
        Rwt << "alert('closing...');"
      end
    end
#    puts Rwt.code
    Rwt.code.should include("#{c1}.on('close',function(){alert('closing...')")
  end

  it "should accept events with parameters" do
    c1=component('one') do |one|
      one.on('close',:first_par,:second_par) do
        Rwt << "alert('closing...'+first_par+second_par);"
      end
    end
#    puts Rwt.code
    Rwt.code.should include("#{c1}.on('close',function(first_par,second_par){alert('closing...'+first_par+second_par)")
  end

  # Missing methods in ruby are passed 'as is' to javascript (crazy!)
  #
  it "should pass missing methods 'as is' to javascript" do
    component('one') do |one|
      one.on('close') do
        one.method1
        one.method2(:par1=>'val1',:par2=>'val2')
      end
    end
#    puts Rwt.code
  end

  # So, you can do things like this:
  it "should be able to generate abitrary method calls in javascript" do
    w='a window to be created'
    b='a button to be created inside a window'
    w=component('window') do |window|
      b=component('button') do |button|
        button.on('click') do
          window.close
        end
      end
    end
#    puts Rwt.code
    Rwt.code.should include("#{b}.on('click',function(){#{w}.close();")
  end


  it "should minify javascript" do
    Rwt.clear
    Rwt.set(:minify=>true)
    Rwt << "
       alert('a');
       alert('b');
       alert('c');
      "
    Rwt.code.should include("alert('a');alert('b');alert('c');")
#    puts Rwt.code
  end

  # A window with tree closing buttons...
  it "should be scriptable" do
    component('a window') do |w|
      1.upto(3) do |n|
        component("button#{n}") do |button|
          button.on('click') do
            w.close
          end
        end
      end
    end
#    puts Rwt.code
  end

end
