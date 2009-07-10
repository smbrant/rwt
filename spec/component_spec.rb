require 'rwt'
include Rwt

describe Rwt::Component do
  before(:each) do
    Rwt.clear
  end

  it "should generate javascript in the buffer" do
    component(:test=>'test')
#    puts Rwt.code
    Rwt.code.should include("test:'test'")
  end

  it "should be able to construct a hierachy of components" do
    a_gf=component('grandfather') do |gf| # gf here only needed because of reference in son
      component('father') do |f|
        f.owner.config[:text].should == 'grandfather'
        component('son') do |s|
          s.owner.config[:text].should == 'father'
          s.on("create") do
            Rwt << "#{gf}.show();"
#            gf.show()  # remember this mode later. Why did I quit with this?
          end
        end
      end
    end
#    puts Rwt.code
#    puts a_gf.vid

    Rwt.code.should include("#{a_gf}.show()")
  end

  it "should return component internal javascript id with to_s" do
    comp= component(:who=>'some_component')
    #    puts "#{comp}"
    "#{comp}".should == comp.config[:v]
  end

  it "should have sons 'seeing' fathers in javascript" do
    father=component(:who=>'father') do |f|
      component(:who=>'son',
        :handler=>function("#{f}.close()")  # e.g., a son that closes the father...
      )
    end
#    puts Rwt.code
    Rwt.code.should include("function(){#{father.config[:v]}.close()}")
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

  it "should generate on events" do
    cmp=component('test') do |c|
      c.on('show',:p1,:p2) do
        Rwt << "alert('parameters: p1='+p1+', p2='+p2);"
      end
    end
    Rwt.code.should include("#{cmp}.on('show',function(p1,p2){alert('parameters: p1='+p1+', p2='+p2);")
  end

#disabled, a bit dangerous...
#
#  it "should be scriptable" do
#    1.upto(3) do |x|
#      component(:who=>"cp#{x}")
#    end
#    a=component(:who=>'a')
#    1.upto(3) do |x|
#      a.showxxx.met2('a','b').met3('1',x).semicolon  # automatically translated to javascript with semicolon at end
#      Rwt.code.should include("#{a.config[:v]}.showxxx().met2('a','b').met3('1',#{x});")
#    end
#    a.showyyy('1',2) # automatically translated without semicolon at end
#    Rwt.js(";alert('x');") # explicit javascript inserted
#    Rwt.code.should include(";alert('x');")
##    puts Rwt.code
#  end

end
