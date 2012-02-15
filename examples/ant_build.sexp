[:nokogori, :tag, 'project', nil,
  [:nokogiri, :attr, 'name', 'Hello', nil],
  [:nokogiri, :attr, 'default', 'compile', nil],

  [:nokogiri, :tag, 'target', nil,
    [:nokogiri, :attr, 'name', 'clean', nil],
    [:nokogiri, :attr, 'description', 'remove intermediate files', nil],

    [:nokogiri, :tag, 'delete', nil,
      [:nokogiri, :attr, 'dir', 'classes', nil]]],

  [:nokogiri, :tag, 'target', nil,
    [:nokogiri, :attr, 'name', 'clobber', nil],
    [:nokogiri, :attr, 'description', 'remove all artifact files', nil],

    [:nokogiri, :tag, 'delete', nil,
      [:nokogiri, :attr, 'file', 'hello.jar', nil]]],
  
  [:nokogiri, :tag, 'target', nil,
    [:nokogiri, :attr, 'name', 'compile', nil],
    [:nokogiri, :attr, 'description', 'compile the Java source code to class files', nil],

    [:nokogiri, :tag, 'mkdir', nil,
      [:nokogiri, :attr, 'dir', 'classes', nil],

      [:nokogiri, :tag, 'javac', nil,
        [:nokogiri, :attr, 'srcdir', '', nil],
        [:nokogiri, :attr, 'destdir', 'classes', nil]]]]]
