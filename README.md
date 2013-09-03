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
<article id="the-trial">
  <h1>The Trial</h1>
  <section id="chapter-1">
    <h2>Chapter 1</h2>
    <p>Someone must have been telling lies about Joseph K. [...]</p>
  </section>
  <section id="chapter-2">
    <h2>Chapter 2</h2>
    <p>K. was informed by telephone [...]</p>
  </section>
</article>
```

Usage
-----

```ruby
article = Smarky.parse('This is some *sweet* Markdown.')
# => a Smarky::Element representing the top-level <article>

article.children
# => an array of Smarky::Element objects (w/ #to_html and #inner_html methods)

article.sections
# => an array of just the child sections (useful for, e.g., a table of contents)

article.to_html
# => the structured HTML

article.inner_html
# => if you want to inject the HTML into an existing container
```

Choosing a Markdown renderer
----------------------------

Smarky lets you pick which Markdown renderer you want to use. Right now you have three options:

- [Redcarpet](https://github.com/vmg/redcarpet)
- [Maruku](https://github.com/bhollis/maruku)
- [Kramdown](https://github.com/gettalong/kramdown)

To specify a renderer, pass an options hash with `:markdown_renderer` to `Smarky.parse`:

    Smarky.parse(markdown, :markdown_renderer => :kramdown)

Obviously, you'll need the appropriate gem installed in order to use it (Smarky doesn't eagerly specify a dependency on any of them). The default is currently Redcarpet.
