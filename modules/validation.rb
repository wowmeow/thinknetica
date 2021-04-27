module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validates

    def validates
      @validates ||= {}
    end

    def validate(name, *args)
      validates[name] = *args
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    protected

    def validate!
      self.class.validates.each do |name, args|
        args_last = args.count
        send((args[0]).to_s, name, *args[1, args_last])
      end
    end

    def presence(name)
      value = instance_variable_get("@#{name}")
      raise "Value can't be nil or empty" if value.nil? || value.empty?
    end

    def format(name, format)
      raise 'Invalid format!' if name !~ format
    end

    def type(name, class_name)
      raise 'Invalid class type' if name.class != class_name
    end
  end
end
