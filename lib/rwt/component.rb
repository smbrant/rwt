module Rwt
  #
  #  Rwt::Component
  #  ==============
  #  
  #  The basic Rwt component.
  #  
  #  A component have a representation in ruby and a corresponding representation
  #  in javascript that can be seen by issuing the render method.
  #  
  #  Normally the render method will be issued only once by the rwt_template
  #  routine and sent to the client for execution (presentation) in the browser.
  #  
  #  Every component is a container and the collection 'components' stores the
  #  contained components (children). If a contained component is a visual
  #  component it will be part of the visual appearance of the container.
  #  
  #  Configuration parameter's names are underscore_separated. They normally
  #  correspond to accessors with the same names.
  #  
  #  Any parameter not recognized by Rwt components are forwarded directly to
  #  the corresponding ExtJS component (and normally use the camelCase syntax).
  #  
  #  Use
  #  ===
  #  
  #  The basic form of use is creating instances of the components in the views
  #  activated by rwt_template:
  #  
  #  component(:config_par1=>value1,....) do |parent|
  #    parent.config_par2= 'Test'
  #    parent << component(....) do |son|
  #      son.property1= 'value'
  #      son.on_change= ....
  #    end
  #  end
  #
  def component(*config,&block)
    Component.new(*config,&block)
  end
  class Component
    @@id= 0

    attr_reader :components
    attr_reader :config
    attr_accessor :owner

    # Default @config initialization
    # Components that accepts parameters in default order should override this
    def init_default_par(non_hash_params)
       @config[:text]=non_hash_params[0] if non_hash_params[0].class == String
    end

    def init_cmp
      # If necessary, override in derived component
    end    
    
    def initialize(*config)
      @config={}
      non_hash=[]
      config.each do |p|
        case p
          when Hash # put all hashs in @config
            @config.merge!(p)
          else # the rest of parameters will be passed to init_default_par, override if necessary
            non_hash << p
        end
      end
      init_default_par(non_hash)

      @config[:id]= "rwt_#{@@id+=1}" if !@config[:id]

      @components= @config.delete(:components) || []

      init_cmp
      
      if block_given?
        yield self
      end
    end

    def <<(child)
      case child
        when Array # children
          child.each do |c|
            c.owner= self if child.class.ancestors.include?(Rwt::Component)
          end
          @components+= child
        else # a child
          child.owner= self if child.class.ancestors.include?(Rwt::Component)
          @components << child
      end
      return child
    end

    def render  # Should be overriden in derived class, this is the default render
      items= @config.delete(:items) || []
      items+= @components
      @config.merge!(:items=>items) if items.length > 0
      @config.render
    end

    def hide
      function("Ext.getCmp('#{@config[:id]}').hide()")
    end
    
    def show
      function("Ext.getCmp('#{@config[:id]}').show()")
    end
    
    

    def program(*code)
      ComponentProgram.new(*code)
    end

    def prepare_owner # Create local callbacks for this component
      js( 
        "var errJs=function(response,options){",  # Error callback
        "};",
        "var exeJs= function(){};",               # Javascript execution callback (will be redefined by pass_owner)

        "var getJs=function(url){",               # getJs for this component (local var)
          "Ext.Ajax.request({",
            "url: url,",
            "success: exeJs,",
            "failure: errJs",
          "});",
        "}"
        ).render
    end

    def pass_owner(owner) # Redefines exeJs for this component (owner redefined)
      js( 
        "exeJs= function(xhttp){",             # Local javascript execution callback (created in prepare_owner)
          "var ret=eval(xhttp.responseText+'(#{owner})');", #   Execute received js
          #not working in IE, pass Rwt allways, so, the js must be in the form (function(...){..})
#          "if(typeof(ret)=='function'){",      #   If a function
#            "eval(ret(#{owner}))",             #     Call function passing owner component
#          "}",
        "}"
        ).render
    end
    
    def owner  # just returns a javascritp var named 'owner' (it is passed to the js creation function)
      aowner=var()
      aowner.name='owner'
      return aowner
    end
    
    def jsObject  # get the real js object
#      "Ext.getCmp('#{@config[:id]}')"  # ask Ext to find the real object
      "Ext.get('#{@config[:id]}')"  # ask Ext to find the real object
    end
    
    
  end 
  
  #
  #  Rwt::ComponentProgram
  #  =====================
  #  
  #  Represents a code snippet in javascript. The code will be wrapped in a function
  #  definition, so that it can be called later passing the caller (owner).
  #  
  #  Initialization parameters: a list of expressions. 
  #  If the expression is an object having the render_program method, the return 
  #  of render_program will be inserted, followed by semicolon.
  #  If the expression is a string, it will be inserted too, followed by semicolon.
  #  Any other expressions have no effect in the result, but are evaluated.
  #  
  #  Example of use
  #  ==============
  #  
  #  puts ComponentProgram.new("alert('test')","alert('test2')").render
  #  
  #  output:
  #   "function(owner){alert('test');alert('test2');}"
  #
  class ComponentProgram
    def initialize(*code)
      @code= code
    end

    def prologue
      "(function(owner){"
    end
    
    def epilogue
      '})'  #()
    end
    
    def render
      js=prologue
      @code.each do |c|
        if c.respond_to?('render_program') # let the object do render_program (if it knows how)
          js << c.render_program << ';'    # presumably a javascript command, so add a semicolon
        else
          if c.class == String
            js << c << ';' # pass the string directly, you know what you're doing! 
          end
        end
      end
      return js+epilogue
    end
  end

# During transition to new Rwt, let the following methods be accessed externally too:
    def prepare_owner # Create local callbacks for this component
      js( 
        "var errJs=function(response,options){",  # Error callback
        "};",
        "var exeJs= function(){};",               # Javascript execution callback (will be redefined by pass_owner)

        "var getJs=function(url){",               # getJs for this component (local var)
          "Ext.Ajax.request({",
            "url: url,",
            "success: exeJs,",
            "failure: errJs",
          "});",
        "}"
        ).render
    end

    def pass_owner(owner) # Redefines exeJs for this component (owner redefined)
      js( 
        "exeJs= function(xhttp){",             # Local javascript execution callback (created in prepare_owner)
          "var ret=eval(xhttp.responseText+'(#{owner})');", #   Execute received js
          #not working in IE, pass Rwt allways, so, the js must be in the form (function(...){..})
#          "if(typeof(ret)=='function'){",      #   If a function
#            "eval(ret(#{owner}))",             #     Call function passing owner component
#          "}",
        "}"
        ).render
    end
    
    def owner  # just returns a javascritp var named 'owner' (it is passed to the js creation function)
      aowner=var()
      aowner.name='owner'
      return aowner
    end

end