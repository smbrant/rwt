#
#  Rwt - Copyright (c) 2008 accesstecnologia.com.br
#
#  Utilities
#
#  Revisions:
#    Dec 09 2008, smb, for rwt version 2
#

##
##  js
##  ==
##
##  returns the list of parameters concatenates as strings
##
##  use
##  ===
##
##  js("alert('test1');","alert('test2');")
##
#def js(*code)
# text=''
#  code.each do |c|
#    text<< c
#  end
#  return text
#end


#
#  JS: class to render explicit javascript in the rwt ruby templates:
#  
#  Use:
#  
#  JS.new("var x= 'test';",
#         "alert(x);",
#         window('Test Window')
#        )
#
#  Or:
#  win= window('Test Window')
#  js("var x= 'test';",
#     "alert(x);",
#     win.show
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
      if c.respond_to?('render')
        js<< c.render
      else
        js<< c
      end
    end
    return js+epilogue
  end
  
end

#
#  Function: class to render a javascript function
#
#  Use:
#
#  Function.new(:x,
#         "alert(x)"
#        )
#
#  Or:
#  js(:x,
#     "alert(x);"
#     )
#
#  Note:
#  function() acts like js(), but consider any symbol passed as a parameter to be
#  put in the javascript function definition.
#
def function(*code)
  Function.new(*code)
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
    super(*(@code-@par)) # pass parameter that are not symbols to a normal JS
  end
  def prologue
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
#  fill_array
#  ==========
#
#  Returns the inside part of a Array equivalent javascript
#
def fill_array(config)
  nitems= config.length
  item=0
  js=''
  config.each do |value|
    item+=1
    if value.respond_to?(:render) # you can define render for any value passed
      js<< value.send(:render)
    else
      if value.class == String
        escaped= value.gsub("'") {|match| "\\\'"}
        js<< "'#{escaped}'"
      elsif value.class == Time
        js<< "'#{value}'"
      else
        js<< "#{value}"
      end
    end
    if item < nitems then
      js<<','
    end
  end
  return js
end

#
#  fill_hash
#  
#  Returns the inside part of a Hash equivalent javascript
#
def fill_hash(config)
  nitems= config.length
  item=0
  js=''
  config.each do |key,value|
    item+=1
    js<< "#{key}:"
    if value.respond_to?(:render) # you can define render for any value passed
      js<< value.send(:render)
    else
      if value.class == String
        escaped= value.gsub("'") {|match| "\\\'"}
        js<< "'#{escaped}'"
      elsif value.class == Time
        js<< "'#{value}'"
      else
        js<< "#{value}"
      end
    end
    if item < nitems then
      js<<','
    end
  end
  return js
end
