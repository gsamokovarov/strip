class Strip::Parser
  autoload :LineBasedParsing, 'strip/parser/line_based_parsing'
  autoload :StackSupport,     'strip/parser/stack_support'
  autoload :NodeSupport,      'strip/parser/node_support'

  include LineBasedParsing
  include StackSupport
  include NodeSupport

  set_default_options :tabsize => 2

  before_each_parsing do
    next_line! while line.empty?

    unless stack.empty?
      if line.indentation <= stack.top.line.indentation
        until line.indentation == stack.top.line.indentation
          # Pop the stack elements, until we find a tag on our level.
          stack.pop
          # Raise syntax error if there was no such indentation before.
          syntax_error 'No matching indentation found' if stack.empty? 
        end
        # Raise also if the element is on the root level.
        syntax_error 'There is already a root' if stack.top.root?
        # Ok, we are on the right indentation, but there is still an element
        # in the stack that is on the current level.
        stack.pop
      end
    end
  end

  parsing do
    case line
    when node(:tag)
      parsing_tag
    when node(:text)
      parsing_text
    end
  end

  parsing_tag do
    stack.push node(:tag).from(line, :parent => stack.top)

    line.expect(/\s*/) 

    line.scan(node(:attr), :after => /\s*/) do 
      parsing_attr
    end

    line.expect(/\s*/)

    line.scan(node(:text)) do
      parsing_inline_text
    end

    unless line.postmatch.strip.empty?
      syntax_error 'Expected attribute or text node'
    end
  end

  parsing_attr do
    stack.top << node(:attr).from(line)
  end

  parsing_text do
    stack.top << node(:text).from(line)
  end

  parsing_inline_text do
    stack.top << node(:text).from(line)
  end

  parsing_done do
    unless stack.empty?
      stack.pop until stack.top.root?
      stack.top.to_exp
    else
      []
    end
  end
end
