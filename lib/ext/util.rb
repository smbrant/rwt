#
#  ExtLib - Copyright (c) 2008 accesstecnologia.com.br
#
#  Utilities
# 
#  Revisions:
#   01/05/08, smb, initial version
#   15/05/08, smb, refactored & commented
#   03/06/08, smb, new method_missing in Var
#

require File.join(File.dirname(__FILE__),'list')

# Javascript utilities:

#
#  JS: class to render explicit javascript in the rwt ruby templates:
#  
#  Use:
#  
#  JS.new("var x= 'test';",
#         "alert(x);",
#         Ext::Window.new(:title=>'Test Window')
#        )
#
#  Or:
#  js("var x= 'test';",
#     "alert(x);",
#     Ext::Window.new(:title=>'Test Window')
#     )
#  
#  Note:   
#  JS accepts as parameters any number of objects. If the object has a method
#  called 'render' it calls this method and append the result to the string returned.
#  If the object don't know how to render, it tries to convert the object to string 
#  and appends it to the string returned.
#
def js(*code)
  JS.new(*code)
end

class JS
  def initialize(*code)
    @code= code
  end
  
  def prologue
    ''
  end
  def epilogue
    ''
  end
  def render
    js=prologue
    @code.each do |c|
#      js<< Ext::Debug.indent
      if c.respond_to?('render')
        js<< c.render
      else
        js<< c
      end
#      js<< Ext::Debug.lf
    end
    return js+epilogue
  end
  
end


#
#  Program: class to render javascript programs
#  
#  Use:
#  
#  Program.new(win=var(Ext::Window.new(:title=>'test',:show=>false)),
#              win.show()
#             )
#
#  Or:
#  program(win=var(Ext::Window.new(:title=>'test',:show=>false)),
#          win.show()
#         )
#  
#  Note:   
#  Program accepts as parameters any number of objects. If the object has a method
#  called 'render_program' it calls this method and append the result to the string returned.
#  It renders strings too, but does not try to render other objects.
#  It allways adds a semicolon (';') after each rendered parameter.
#  (if you passes a String, you should know what you are doing, it goes direct to the generated javascript).
#  
#  You can use js() to better layout your javascript code:
#  
#  program(
#      ....,
#      js('alert("asdf");',
#         'alert("xxxx");'
#      ),
#      ....
#   )
#  
#  
#
def program(*code) # js alias, but renders only strings
  Program.new(*code)
end

class Program
  def initialize(*code)
    @code= code
  end
  
  def prologue
    '(function(owner){' # for use in new rwt
  end
  def epilogue
    '})' #() for use in new rwt
  end
  def render
    js=prologue
    @code.each do |c|
      js<< Ext::Debug.indent
      if c.respond_to?('render_program') # let the object do render_program (if it knows how)
        js << c.render_program << ';'    # presumably a command, so add a ';'
      else
        if c.class == String
          js << c << ';' # pass the string directly, you know what you're doing! 
        end
      end
      js<< Ext::Debug.lf
    end
    return js+epilogue
  end
end

#
#  Snippet: The same as Program, without encapsulating prologue/epilogue
#  
def snippet(*code)
  Snippet.new(*code)
end
class Snippet < Program
  def prologue
    ''
  end
  def epilogue
    ''
  end
  
end

class Function < JS
  def initialize(*code)
    @code= code
    @par=[]
    @code.each do |c|
      case c
      when Symbol
        @par << c
      end
    end
#    @code-=@par
    super(*(@code-@par))
  end
  def prologue
#    'function(){'
    js= 'function('
    @par.each do |p|
      js << p.to_s
      if (p != @par[@par.length-1])
        js << ','
      end
    end
    js << '){'
  end
  def epilogue
    '}'
  end
end

#
# renders javascript: function(){what_you_pass}
#
def function(*code)
  Function.new(*code)
end


#
# Var: encapsulates a javascript variable
# 
# Only render_program if object defined! (and in this case calls object.render)
# 
# If a named variable ('name' attribute set), encapsulates rendered code with:
# 
# if(!variable){
#   variable= rendered code
# }
# 
# (that is, if the variable already exists, don't create it again)
#
def var(config=nil,&block)
  Var.new(config,&block)
end

class Var
  @@count=0  # unique id generator
  attr_reader :name
  attr_accessor :object

  def initialize(obj=nil)
#    @prefix= 'App.'
    @prefix= ''  # don't use prefix anymore (if needed, pass the full name)
    @@count+= 1
    @name= "v#{@@count}"  # generated javascript variable name
    @named= false
    @object= obj # the ruby object corresponding to javascript variable
    if block_given?
      yield self
    end
  end

  def name=(value)
    @named= true
    @name= value
  end
  
  def render_program
    if @object
      js(@named ? "if(!#{@prefix}#{@name}){":'' ,@named ? @prefix : 'var ',self.name,'=',self.object, @named ? '}' :'' ).render
    else
      ''
    end
  end
  
  def jsObject  # get the real js object
    case @object
      when Hash  # the var object is a hash (representing the future js object)
        js("Ext.getCmp('#{@object[:id]}')")  # ask Ext to find the real object
      else
        js(self.name) # I am an js object
    end
  end
  
  def render
    if @named
      "#{@prefix}#{@name}"
    else
      "#{@name}"
    end
  end
  
  def to_s
    render
  end
  
  
  # Transforms unexpected method calls in correspondent javascript method calls
  # (translating Var instances in javascript var names)
  def method_missing(*args,&block)
    m= args.shift
#    puts "m=#{m}-",m.class
    args_fixed=[]
    i=0
    args.each() do |arg|
      if i > 0
        args_fixed << ','
      end
      i+=1
      if arg.respond_to?('render')
        args_fixed << arg.render
      else
        args_fixed << arg
      end
    end
    if m.to_s.include?('=')
#      s=js(@named ? @prefix : '',self.name,".#{m.to_s}",js(*args_fixed)).render
      VarPropertyAssign.new(self,m.to_s,js(*args_fixed))
    else  
      js(@named ? @prefix : '',self.name,".#{m.to_s}(",js(*args_fixed),')').render
    end
  end
  
end

class VarPropertyAssign #ainda nao esta funcionando, melhorar
  def initialize(var,property,value)
    @var= var
    @property= property
    @value= value
  end
  
  def render_program
      js(@var,'.',@property,@value).render
  end
end

# Especific to Ext:
module Ext
  class JS_onReady < JS
    def prologue
      'Ext.onReady(function(){'
    end
    def epilogue
      '});'
    end
  end  

  def self.onReady(*code)
    JS_onReady.new(*code)
  end

  #
  #  fillArray
  #  
  #  Returns the inside part of an Array equivalent JSON
  #
  def self.fillArray(config)
    Ext::Debug.incr_indent
    nItems= config.length
    item=0
    js=''
    config.each do |value|
      item+=1
      if value.respond_to?(:render) # you can define render for any value passed
        js<< value.send(:render)
      else
        if value.class == String
          escaped= value.gsub("'") {|match| "\\\'"}
          js<< Ext::Debug.indent+"'#{escaped}'"
        elsif value.class == Time
          js<< Ext::Debug.indent+"'#{value}'"
        else
          js<< Ext::Debug.indent+"#{value}"
        end
      end
      if item < nItems then 
        js<<','
      end
      Ext::Debug.lf
    end
    Ext::Debug.decr_indent
    return js
  end

  #
  #  fillHash
  #  
  #  Returns the inside part of a Hash equivalent JSON
  #
  def self.fillHash(config)
    Ext::Debug.incr_indent
    nItems= config.length
    item=0
    js=''
    config.each do |key,value|
      item+=1
      js<< Ext::Debug.indent+"#{key}:"
      if value.respond_to?(:render) # you can define render for any value passed
        js<< value.send(:render)
      else
        if value.class == String
          escaped= value.gsub("'") {|match| "\\\'"}
          js<< Ext::Debug.indent+"'#{escaped}'"
        elsif value.class == Time
          js<< Ext::Debug.indent+"'#{value}'"
        else
          js<< "#{value}"
        end
      end
      if item < nItems then 
        js<<','
      end
      Ext::Debug.lf
    end
    Ext::Debug.decr_indent
    return js
  end
  
  # Debugging facilities
  
  #
  #  ExtLib Debugging facilities
  #
  module Debug
    @@debug= false
    @@indentation= 0

    #
    #  Starts debbuging mode (indents & newlines)
    #
    def self.start
      @@debug= true
    end

    #
    #  Returns true if debugging started
    #
    def self.active?
      @@debug
    end

    #
    #  Stops debbuging mode
    #
    def self.stop
      @@debug= false
    end

    #
    #  Returns the indentation string if in debugging mode
    #
    def self.indent
      if @@debug
        '  '*@@indentation
      else
        ''
      end
    end

    #
    #  Returns \n if in debugging mode
    #
    def self.lf
      if @@debug
        "\n"
      else
        ''
      end
    end

    #
    #  Increments the indentation level
    #
    def self.incr_indent
      @@indentation+= 1
    end

    #
    #  Decrements the indentation level
    #
    def self.decr_indent
      @@indentation-= 1 if @@indentation > 0
    end
  end
end

# util from ExtJS:
module Ext
  module Util
    module Format
      def self.usMoney
        UsMoney.new
      end
      class UsMoney < Hash;def prologue;'Ext.util.Format.usMoney' end;def epilogue;'' end end
      
      def self.dateRenderer(*config)
        DateRenderer.new(config)
      end
      class DateRenderer < List;def prologue;'Ext.util.Format.dateRenderer(' end;def epilogue;')' end end
    end
  end
end