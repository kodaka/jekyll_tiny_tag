# Jekyll Tiny Tag

Generate each tag-page and use tag-information for [Jekyll](https://jekyllrb.com)

## Features

    <h1>Awsome Post A</h1>
    <h2>Tags for the Post</h2>
    <ol>
        <li><a href="/tags/avengers4/">Endgame</a></li>
        <li><a href="/tags/avengers3/">Infinity War</a></li>
    </ol>

    <h1>Tag: Endgame (123 posts)</h1>
    <ol>
        <li><a href="/2019/04/27/awsome-post-a/">Awsome Post A</a></li>
        ...
    </ol>

    <h1>All Tags (456 tags)</h1>
    <ol>
        <li><a href="/tags/avengers2/">Age of Ultron</a></li>
        <li><a href="/tags/avengers4/">Endgame</a></li>
        <li><a href="/tags/avengers3/">Infinity War</a></li>
        <li><a href="/tags/avengers1/">Marvel's The Avengers</a></li>
        ...
    </ol>

## Installation

Put `jekyll_tiny_tag.rb` into your `_plugins` directory

## Usage

Tag information produced by this plugin is named **tagging**

### Pages

1. Prepare your `layout` for each tag-page, you can use

       page.tagging.tag   # is the tag you wrote in your front matter
       page.tagging.data  # is your hash data for the tag described in _data/tags.yml
       page.tagging.title # is page.tagging.data.title or tag itself
       page.tagging.slug  # is slugified tag
       page.tagging.url   # is tag-page url
       page.tagging.posts # are posts filtered by the tag

1. (Optional) Set config into `_config.yml`

       # default configs
       tiny_tag:
         dir: tags        # where to output
         layout: tag.html # means _layouts/tag.html for each tag-page
         slug:            # jekyll slug options for dirname of tag-page
           mode: default
           cased: false

1. (Optional) Describe tag data in `_data/tags.yml`

       # key is tag itself
       # value is any hash data you want to use in layout
       avengers:
         title: Marvel's The Avengers
         hulk: smash
         budapest:
           - clint
           - natasha

1. Run Jekyll

### Filters

You can use `tagify` (tags to **tagging**s) and `to_array_of_keys` (hash-key to array)

    alphabetically:
    {% assign taggings = page.tags | tagify %}
    {% assign taggings = site.tags | to_array_of_keys | tagify %}

    latest date:
    {% assign taggings = page.tags | tagify: 'date' %}
    {% assign taggings = site.tags | to_array_of_keys | tagify: 'date' %}

### Examples

#### Example 1

1. `Front Matter` of post

       ---
       tags:
         - avengers
       ---

1. `_data/tags.yml`

       avengers:
         title: Marvel's The Avengers
         hulk: smash

1. `layout` of post

       {% assign taggings = page.tags | tagify %}
       {% for tagging in taggings %}
           {{ tagging.title }}
           {{ tagging.data.hulk }}
       {% endfor %}

1. `layout` of tag-page

       {{ page.tagging.title }}
       {{ page.tagging.data.hulk }}

#### Example 2

1. `Front Matter` of post

       ---
       tags:
         - Marvel's The Avengers
       ---

1. `layout` of tag-page

       <a href="{{ page.tagging.url | relative_url }}">
           {{ page.tagging.title | escape }}
       </a>

#### Example 3

1. `./tags.html`

       ---
       permalink: /tags/
       ---
       {% assign taggings = site.tags | to_array_of_keys | tagify %}
       {% for tagging in taggings %}
           <a href="{{ tagging.url | relative_url }}">
               {{ tagging.title | escape }}
           </a>
       {% endfor %}

## Contribution

[GitHub Repository](https://github.com/kodaka/jekyll_tiny_tag)

## Author

[kodaka](https://github.com/kodaka)

## License

[MIT](https://github.com/kodaka/jekyll_tiny_tag/blob/master/LICENSE)
