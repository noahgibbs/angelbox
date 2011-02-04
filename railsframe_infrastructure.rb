class RailsFrameApp
  ATTRS = [ :name, :github, :default, :mounted ]

  ATTRS.each do |attr|
    define_method(attr) do |param|
      instance_variable_set("@#{attr}", param)
    end

    define_method("get_" + attr.to_s) do
      instance_variable_get("@#{attr}")
    end
  end

  def default!
    @default = true
  end

  def app_name
    return @name if @name
    if @github
      if @github =~ /\//
        return @github.split("/", 2)[1]
      end
      return @github
    end
    raise "Can't figure out app name: #{self.to_hash.inspect}!"
  end

  def to_hash
    hash = {}
    @name ||= app_name
    ATTRS.each do |attr|
      getter = "get_#{attr}"
      hash[attr] = send(getter) if send(getter)
    end
    hash
  end
end

class RailsFrame
  attr_reader :apps

  ATTRS = [:port]
  ATTRS.each do |attr|
    define_method(attr) do |param|
      instance_variable_set("@#{attr}", param)
    end

    define_method("get_" + attr.to_s) do
      instance_variable_get("@#{attr}")
    end
  end

  def initialize(block)
    @apps = []
    #@vagrant_config = vagrant_config
    @http_port = 4444
    @config_block = block
  end

  def self.config(&block)
    @instance = RailsFrame.new(block)

    #@instance.instance_eval(&block)
  end

  def self.get_config
    @instance
  end

  def execute
    instance_eval(&@config_block)
  end

  def vagrant
    @vagrant_config
  end

  def vagrant=(v)
    @vagrant_config = v
  end

  def app(&block)
    new_app = RailsFrameApp.new
    @apps << new_app
    new_app.instance_eval(&block)
  end
end
