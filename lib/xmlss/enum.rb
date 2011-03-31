# common methods used for handling enum data
module Xmlss
  module Enum

    module ClassMethods
      def enum(name, map)
        # TODO: validate name
        unless map.kind_of?(::Hash)
          raise ArguementError, "please specify the enum map as a Hash"
        end

        # define an anonymous Module to extend on
        # defining a class level map reader
        class_methods = Module.new do
          define_method(name) do |key|
            class_variable_get("@@#{name}")[key]
          end
          define_method(name.to_s+'_set') do
            class_variable_get("@@#{name}").keys
          end
        end

        # set a class variable to store the enum map (used by above reader)
        # extend the anonymous module to get tne above class
        #   level reader for the map
        class_eval do
          class_variable_set("@@#{name}", map)
          extend class_methods
        end

        # instance writer for the enum value
        define_method("#{name}=") do |value|
          map = self.class.send(:class_variable_get, "@@#{name}")
          instance_variable_set("@#{name}", if value && map.has_key?(value)
            # write by key
            map[value]
          elsif map.has_value?(value)
            # write by value
            value
          else
            nil
          end)
        end

        # instance reader for the enum value
        define_method(name) do
          instance_variable_get("@#{name}")
        end
      end
    end

    class << self
      def included(receiver)
        receiver.send :extend, ClassMethods
      end
    end

  end
end