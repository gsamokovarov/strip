[:xml, :tag, 'project', nil,
  [:xml, :attr, 'name', 'Hello', nil],
  [:xml, :attr, 'default', 'compile', nil],

  [:xml, :tag, 'target', nil,
    [:xml, :attr, 'name', 'clean', nil],
    [:xml, :attr, 'description', 'remove intermediate files', nil],

    [:xml, :tag, 'delete', nil,
      [:xml, :attr, 'dir', 'classes', nil]]],

  [:xml, :tag, 'target', nil,
    [:xml, :attr, 'name', 'clobber', nil],
    [:xml, :attr, 'description', 'remove all artifact files', nil],

    [:xml, :tag, 'delete', nil,
      [:xml, :attr, 'file', 'hello.jar', nil]]],
  
  [:xml, :tag, 'target', nil,
    [:xml, :attr, 'name', 'compile', nil],
    [:xml, :attr, 'description', 'compile the Java source code to class files', nil],

    [:xml, :tag, 'mkdir', nil,
      [:xml, :attr, 'dir', 'classes', nil],

      [:xml, :tag, 'javac', nil,
        [:xml, :attr, 'srcdir', '', nil],
        [:xml, :attr, 'destdir', 'classes', nil]]]]]
