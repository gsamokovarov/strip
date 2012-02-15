module Strip
  class Parser < Base::Parser
    before_each_parsing do
      next_line! while line.empty?

      unless stack.empty?
        if line.indentation <= stack.top.line.indentation
          until line.indentation == stack.top.line.indentation
            # Pop the stack elements, until we find a tag on our level.
            stack.pop
            # Raise syntax error if there was no such indentation before.
            syntax_error 'No matching indentation found', line if stack.empty? 
          end
          # Raise also if the element is on the root level.
          syntax_error 'There is already a root', line if stack.top.root?
          # Ok, we are on the right indentation, but there is still an element
          # in the stack that is on the current level.
          stack.pop
        end
      end
    end

    parsing do
      case line
      when Tag
        parsing_tag
      when Text
        parsing_text
      end
    end

    parsing_tag do
      stack.push Tag.from_line(line).tap { |tag| tag.parent = stack.top }
      line.scan(Attr) { parsing_attr }
      unless line.postmatch.strip.empty?
        line.scan(Text) { parsing_text }
        syntax_error 'Expected attribute or text node', line
      end
    end

    parsing_attr do
      stack.top << Attr.from_line(line)
    end

    parsing_text do
      stack.top << Text.from_line(line)
    end

    parsing_done do
      unless stack.empty?
        stack.pop until stack.top.root?
        stack.top.to_exp
      else
        String.new
      end
    end
  end
end
