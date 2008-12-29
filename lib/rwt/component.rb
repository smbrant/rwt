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
  #  using some technics detailed later.
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
  #  component(:config_par1=>value1,....) do
  #    config_par2= 'Test'
  #    component(....) do
  #      property1= 'value'
  #    end
  #    1.upto(3) do |x|
  #      component(:text=>x.to_s) # three more sons
  #    end
  #  end
  #
  def component(*config,&block)
    Component.new(self, *config, &block) # self as owner
  end
  class Component
    @@vid= 0 # The var id, id of the corresponding javascript variable
    @@owners= [] # Stack of block owners (a component is 'owner' of his block of code,
                 # so that all components inside the block are owned by the component)

    attr_reader :components
    attr_reader :config
    attr_reader :owner

    # Default @config initialization
    # Components that accepts parameters in default order should override this
    def init_default_par(non_hash_params)
       @config[:text]=non_hash_params[0] if non_hash_params[0].class == String
    end

    def init_cmp
      # If necessary, override in derived component
    end

    def initialize(*config,&block)
      @owner= @@owners.last if @@owners.any? # If have a owner put me in the list of owned
      if @owner.is_a?(Component)
        @owner.components << self
      end

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

      @config[:v]= "v#{@@vid+=1}" if !@config[:v]

      @components= @config.delete(:components) || []

      init_cmp

      if block_given?
        @@owners.push(self)
        yield self
        @@owners.pop
#        instance_eval(&block)
      end

      render_create # Generates the creation of component
#      instance_eval(&@on_create) if @on_create # Generates the on_create event

    end

    def vid
      @config[:v]
    end

    def render
      @config[:v] # Just returns the javascript variable pointing to the object
    end

    def to_s
      render # the same as render to ease interpolation in function() or js()
    end

    # Events:
    def on_create(&block)
      @on_create= block
    end

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

  end

#  # Interface to Component:
#  def component(*config,&block)
#    Component.new(self, *config, &block)
#
#    c=Component.new(self,*config) # Create a new component passing me (whoever I am) as ower
#    if block_given?
#      c.instance_eval(&block)
#    end
#    c.render_create
#    instance_eval(c.on_create) if c.on_create
#  end

end

