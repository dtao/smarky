Smarky
======

Smarky takes [Markdown](http://daringfireball.net/projects/markdown/) and turns it into **structured** (as opposed to *flat*) HTML.

This is easier to show than to explain. Say we have this Markdown:

```markdown
# Title of work

Blah blah blah.

## Chapter 1

Yada yada.

## Chapter 2

Ho hum.
```

Traditional Markdown renderers will translate this to the following HTML:

```html
<h1>Title of work</h1>
<p>Blah blah blah.</p>
<h2>Chapter 1</h2>
<p>Yada yada.</p>
<h2>Chapter 2</h2>
<p>Ho hum.</p>
```

This is *flat*. Smarky will produce this instead:

```html
<article>
  <h1>Title of work</h1>
  <p>Blah blah blah.</p>
  <section>
    <h2>Chapter 1</h2>
    <p>Yada yada.</p>
  </section>
  <section>
    <h2>Chapter 2</h2>
    <p>Ho hum.</p>
  </section>
</article>
```

Usage
-----

```ruby
article = Smarky.parse('This is some *sweet* Markdown.')
# => an <article> Nokogiri::XML::Node

article.inner_html
# => the structured HTML
```
