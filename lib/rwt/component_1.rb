module Rwt

  #
  #  Rwt::Component
  #  ==============
  #
  #  The basic Rwt component.
  #
  #  A component have a representation in ruby and a corresponding representation
  #  in javascript that is constructed during during the instantiation of the
  #  ruby object. The javascript code is added to the code buffer.
  #
  #  The javascript code can be completed with code generated after object instantiation
  #  using some techinics detailed later.
  #
  #  Normally the rwt_render will send the javascript code to the client for
  #  execution (presentation) in the browser.
  #
  #  Every component is a container and the collection 'components' stores the
  #  contained components (children). If a contained component is a visual
  #  component it will be part of the visual appearance of the container.
  #
  #  Configuration parameter's names are underscore_separated. They normally
  #  correspond to accessors with the same names.
  #
  #  Any parameter not recognized by Rwt components are forwarded directly to
  #  the corresponding javascript component (and normally use the camelCase syntax).
  #
  #  Use
  #  ===
  #
  #  The basic form of use is creating instances of the components in the views
  #  activated by rwt_render:
  #
  #  component(:config_par1=>value1,....) do |parent|
  #    parent.config_par2= 'Test'
  #    parent << component(....) do |son|
  #      son.property1= 'value'
  #      son.on_change= ....
  #    end
  #    1.upto(3) do |x|
  #      parent << component(:text=>x.to_s) # three more sons
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


    def text=(value)
      @config[:text]= value
    end
    def text
      @config[:text]
    end

    # Default @config initialization
    # Components that accepts parameters in default order should override this
    def init_default_par(non_hash_params)
       @config[:text]=non_hash_params[0] if non_hash_params[0].class == String
    end


    def init_cmp
      # If necessary, override in derived component
    end

    def initialize(*config)
      @created= false # flags that javascript code to create the component was not put in buffer yet
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

      @config[:id]= "v#{@@id+=1}" if !@config[:id]

      @components= @config.delete(:components) || []

      init_cmp


      if block_given?
        yield self
      end

      Rwt.add_code(render_create)

      @created= true # Code for creation has been put in buffer

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

    # dependent on javascript library - should be plugged in by adapters

    #
    #  render_create
    #  =============
    #
    #  Should generate the javascript code necessary to create the component.
    #  This method should be overriden by adapters.
    #
    def render_create
      "/* Component creation code should be generated here by #{Rwt.adapter} adapter */"
    end

    def render
      @config[:id] # Just returns the javascript variable pointing to the object
    end

    def to_s
      render # the same as render to ease interpolation in function() or js()
    end

#    # Transforms unexpected method calls in correspondent javascript method calls
#    def method_missing(*args,&block)
#      m= args.shift
##     puts "method #{m} called from Component"
#
#      args_fixed=[]
#      args.each() do |arg|
#        if arg.respond_to?('render')
#          args_fixed << arg.render
#        else
#          args_fixed << arg
#        end
#      end
#      Rwt.add_code("#{@config[:id]}.#{m.to_s}(#{fill_array(args_fixed)})")
#      return MethodMissing.new
#
##      if m.to_s.include?('=')
##  #      s=js(@named ? @prefix : '',self.name,".#{m.to_s}",js(*args_fixed)).render
##        VarPropertyAssign.new(self,m.to_s,js(*args_fixed))
##      else
##        js(@named ? @prefix : '',self.name,".#{m.to_s}(",js(*args_fixed),')').render
##
##      end
#    end
  end # Component

  #
  #  MethodMissing
  #  =============
  #
  #  A dummy class to make possible the return of following methods in a chain.
  #
  class MethodMissing
    def method_missing(*args,&block)
      m= args.shift # the method as a symbol
#     puts "method #{m} called from MethodMissing"

      args_fixed=[]
      args.each() do |arg|
        if arg.respond_to?('render')
          args_fixed << arg.render
        else
          args_fixed << arg
        end
      end
      Rwt.add_code(".#{m.to_s}(#{fill_array(args_fixed)})")  # continue with the chain...
      return MethodMissing.new
    end

    def semicolon # may be used do complete a javascript command with semicolon
      Rwt.add_code(";")
    end

#    def MethodMissing.finalize(id)
#      puts "Object #{id} dying at #{Time.new}"
#    end
  end


end