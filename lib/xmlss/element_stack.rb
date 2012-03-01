module Xmlss

  class ElementStack

    # this class is just a wrapper to Array.  I want to treat this as a
    # stack of objects for the workbook DSL to reference.  I need to push
    # an object onto the stack, reference it using the 'current' method,
    # and pop it off the stack when I'm done.

    attr_reader :markup_type

    def initialize(writer, markup_type)
      @stack = []
      @writer = writer
      @markup_type = markup_type
      @written_level = 0
    end

    def empty?; @stack.empty?; end
    def size;   @stack.size;   end
    def first;  @stack.first;  end
    def last;   @stack.last;   end

    alias_method :current, :last
    alias_method :level, :size

    def push(element)
      open(current) if !empty?
      @stack.push(element)
    end

    def pop
      if !empty?
        if @written_level < level
          @stack.pop.tap { |elem| write(elem) }
        else
          @stack.pop.tap { |elem| close(elem) }
        end
      end
    end

    def using(element, &block)
      push(element)
      (block || Proc.new {}).call
      pop
    end

    private

    def open(element)
      write(element)
      @writer.push(@markup_type)
      @written_level += 1
    end

    def close(element)
      @writer.pop(@markup_type)
      @written_level -= 1
    end

    def write(element)
      @writer.write(element)
    end

  end

end
