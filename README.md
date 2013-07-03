Smarky
======

Smarky takes [Markdown](http://daringfireball.net/projects/markdown/) and turns it into **structured** (as opposed to *flat*) HTML.

This is easier to show than to explain. Say we have this Markdown:

```markdown
# The Trial

## Chapter 1

Someone must have been telling lies about Josef K. [...]

## Chapter 2

K. was informed by telephone [...]
```

Traditional Markdown renderers will translate this to the following HTML:

```html
<h1>The Trial</h1>
<h2>Chapter 1</h2>
<p>Someone must have been telling lies about Joseph K. [...]</p>
<h2>Chapter 2</h2>
<p>K. was informed by telephone [...]</p>
```

This is *flat*. Smarky will produce this instead:

```html
<article>
  <h1>The Trial</h1>
  <section>
    <h2>Chapter 1</h2>
    <p>Someone must have been telling lies about Joseph K. [...]</p>
  </section>
  <section>
    <h2>Chapter 2</h2>
    <p>K. was informed by telephone [...]</p>
  </section>
</article>
```

Usage
-----

```ruby
article = Smarky.parse('This is some *sweet* Markdown.')
# => an <article> Nokogiri::XML::Node

article.to_html
# => the structured HTML
```
