module Accessor
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      history = "@#{name}_history".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        if instance_variable_get("@#{name}_history").nil?
          instance_variable_set(history, [])
        else
          instance_variable_get(history) << instance_variable_get(var_name)
        end
        instance_variable_set(var_name, value)
      end
      define_method("#{name}_history") { instance_variable_get(history) }
    end
  end

  def strong_attr_accessor(name, class_name)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      value.is_a?(class_name) ? instance_variable_set(var_name, value) : (raise 'Type of the value is incorrect!')
    end
  end
end
