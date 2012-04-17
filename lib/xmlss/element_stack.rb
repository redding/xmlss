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
      @markup_type = markup_type.to_s
      @written_level = 0
    end

    def empty?; @stack.empty?; end
    def size;   @stack.size;   end
    def first;  @stack.first;  end
    def last;   @stack.last;   end

    alias_method :current, :last
    alias_method :level, :size

    def using(element, &block)
      push(element)
      (block || Proc.new {}).call
      pop
    end

    def push(element)
      if @written_level < level
        write(current)
        @writer.push(@markup_type)
        @written_level += 1
      end
      @stack.push(element)
    end

    def pop
      if !empty?
        @written_level < level ? write(@stack.pop) : close(@stack.pop)
      end
    end

    private

    def close(element)
      @writer.pop(@markup_type)
      @written_level -= 1
      element
    end

    def write(element)
      @writer.write(element)
      element
    end

  end

end
