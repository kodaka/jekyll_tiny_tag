# Jekyll Tiny Tag

[Jekyll](https://jekyllrb.com) Plugin to generate each tag-page and use tag-information.

## Features

~~~html
<h1>Awsome Post A</h1>
<h2>Tags for the Post</h2>
<ol>
    <li><a href="/tags/avengers4/">Endgame</a></li>
    <li><a href="/tags/avengers3/">Infinity War</a></li>
</ol>
~~~

~~~html
<h1>Tag: Endgame (123 posts)</h1>
<ol>
    <li><a href="/2019/04/27/awsome-post-a/">Awsome Post A</a></li>
    ...
</ol>
~~~

~~~html
<h1>All Tags (456 tags)</h1>
<ol>
    <li><a href="/tags/avengers2/">Age of Ultron</a></li>
    <li><a href="/tags/avengers4/">Endgame</a></li>
    <li><a href="/tags/avengers3/">Infinity War</a></li>
    <li><a href="/tags/avengers1/">Marvel's The Avengers</a></li>
    ...
</ol>
~~~

## Installation

Put `jekyll_tiny_tag.rb` into your `_plugins` directory

## Usage

Tag information produced by this plugin is named **tagging**.

### Pages

1. Prepare your `layout` for each tag-page.
   `page` of tag-page already has **tagging**.

   |Liquid|meaning|eg|
   |:-|:-|:-|
   |`page.tagging.tag`|the `tag` you wrote in your `front matter`|avengers part 4|
   |`page.tagging.data`|your tag data for the `tag` described in `_data/tags.yml`|`{'title': 'Endgame', 'hulk': 'smash'}`|
   |`page.tagging.title`|`page.tagging.data.title` or `tag` itself|Endgame|
   |`page.tagging.slug`|slugified `tag`|avengers-part-4|
   |`page.tagging.url`|`url` of tag-page|/tags/avengers-part-4/|
   |`page.tagging.posts`|`posts` filtered by the `tag`|`[post1, post2, ...]`|

1. (Optional) Set config into `_config.yml`

   ~~~yaml
   # defaults
   tiny_tag:
     dir: tags        # where to output
     layout: tag.html # means _layouts/tag.html for each tag-page
     slug:            # jekyll slug options for tagging.slug
       mode: default
       cased: false
   ~~~

1. (Optional) Describe tag data in `_data/tags.yml`

   ~~~yaml
   # key is tag itself
   # value is any hash data you want to use in layout
   avengers:
     title: Marvel's The Avengers
     hulk: smash
     budapest:
       - clint
       - natasha
   ~~~

1. Run Jekyll

### Filters

`page` except tag-page do not have **tagging**(s),
you have to get with filters.
You can use `tagify` (tags to **tagging**s)
and `to_array_of_keys` (hash-key to array)

~~~html
sort-mode: none (default, as-is)
{% assign taggings = page.tags | tagify %}
{% assign taggings = site.tags | to_array_of_keys | tagify %}

sort-mode: date (latest post date)
{% assign taggings = page.tags | tagify: 'date' %}
{% assign taggings = site.tags | to_array_of_keys | tagify: 'date' %}

sort-mode: title (alphabetically)
{% assign taggings = page.tags | tagify: 'title' %}
{% assign taggings = site.tags | to_array_of_keys | tagify: 'title' %}
~~~

### Examples

#### Using Slugified Tags

1. `front matter` of post

   ~~~yaml
   ---
   tags:
     - avengers
   ---
   ~~~

1. `_data/tags.yml`

   ~~~yaml
   avengers:
     title: Marvel's The Avengers
     hulk: smash
   ~~~

1. `layout` of post

   ~~~html
   {% assign taggings = page.tags | tagify %}
   {% for tagging in taggings %}
       {{ tagging.title }}
       {{ tagging.data.hulk }}
   {% endfor %}
   ~~~

1. `layout` of tag-page

   ~~~html
   {{ page.tagging.title }}
   {{ page.tagging.data.hulk }}
   ~~~

#### Using Entitled Tags

1. `front matter` of post

   ~~~yaml
   ---
   tags:
     - Marvel's The Avengers
   ---
   ~~~

1. `layout` of tag-page

   ~~~html
   <a href="{{ page.tagging.url | relative_url }}">
      {{ page.tagging.title | escape }}
   </a>
   ~~~

#### Page of All-Tags

1. `./tags.html`

   ~~~
   ---
   permalink: /tags/
   ---
   {% assign taggings = site.tags | to_array_of_keys | tagify: 'title' %}
   {% for tagging in taggings %}
       <a href="{{ tagging.url | relative_url }}">
           {{ tagging.title | escape }}
       </a>
   {% endfor %}
   ~~~

## Contribution

[GitHub Repository](https://github.com/kodaka/jekyll_tiny_tag)

## Author

[kodaka](https://github.com/kodaka)

## License

[MIT](https://github.com/kodaka/jekyll_tiny_tag/blob/master/LICENSE)
