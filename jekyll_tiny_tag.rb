module JekyllTinyTag
    class Config
        attr_reader :dir, :layout, :slug_mode, :slug_cased
        def initialize(site)
            config = site.config['tiny_tag'] || {}
            
            @dir        = config.dig('dir')           || 'tags'
            @layout     = config.dig('layout')        || 'tag.html'
            @slug_mode  = config.dig('slug', 'mode')  || 'default'
            @slug_cased = config.dig('slug', 'cased') || false
        end
    end

    class Tagging < Liquid::Drop
        attr_reader :tag
        def initialize(site, tag)
            @site   = site
            @config = Config.new(site)
            @tag    = tag
        end

        def posts
            @site.tags[tag]
        end

        def data
            @data ||= @site.data.dig('tags', tag) || {}
        end

        def title
            @title ||= data.fetch('title', tag)
        end

        def slug
            @slug ||= Jekyll::Utils.slugify(tag, :mode => @config.slug_mode, :cased => @config.slug_cased)
        end

        def url
            @url ||= "/#{@config.dir}/#{slug}/"
        end
    end

    class Generator < Jekyll::Generator
        def generate(site)
            config = Config.new(site)
            site.tags.each_key do |tag|
                tagging = Tagging.new(site, tag)
                site.pages << Page.new(
                    site, 
                    site.source, 
                    File.join(config.dir, tagging.slug),
                    config.layout,
                    tagging
                )
            end
        end
    end

    class Page < Jekyll::Page
        def initialize(site, base, dir, layout, tagging)
            @site = site
            @base = base
            @dir  = dir
            @name = 'index.html'

            self.process(@name)
            self.read_yaml(File.join(base, '_layouts'), layout)
            self.data['tagging'] = tagging
        end
    end

    module Filter
        def to_array_of_keys(hash)
            hash.keys
        end

        def tagify(tags, sort_mode = nil)
            sort_mode ||= 'default'

            taggings = tags.map{|tag| Tagging.new(@context.registers[:site], tag)}
            
            if sort_mode === 'date' then
                taggings.sort_by{|t| [-t.posts[0].date.to_time.to_i, t.title, t.tag]}
            elsif sort_mode === 'title' then
                taggings.sort_by{|t| [t.title, t.tag]}
            else
                taggings
            end
        end
    end    
end

Liquid::Template.register_filter(JekyllTinyTag::Filter)
