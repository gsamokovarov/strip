Strip - XML for humans and stuff
================================

Strip is a markup language which makes writing XML by hand a more pleasant experience.

Overview
========

Tags
----

A tag is the first word on the line.

```
root
```

```xml
<?xml version="1.0"?>
<root/>
```

In the spirit of the recent markup and template languages movement, the tag are nested into each other using semantic indentation.

```
root
  child
    grand-child
```

```xml
<?xml version="1.0"?>
<root>
  <child>
    <grand-child/>
  </child>
</root>
```

Attributes
----------

Attributes follow a tag, pretty much like in regular XML.

```
root attribute="value" another-one="value"
```

```xml
<?xml version="1.0"?>
<root attribute="value" another-one="value"/>
```

The attribute delimiters are whitespaces.

Text
----

Text nodes are denoted by the pipe `|` character.

```
root
  | Hey, I'm a text node.
```

```xml
<?xml version="1.0"?>
<root>Hey, I'm a text node.</root>
```

The text is automatically escaped and any further `|` characters are represented as is.
