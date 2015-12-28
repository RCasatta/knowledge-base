require 'yaml'

module Jekyll

  class CommonData
    def initialize(site, base)
      @site = site
      @base = base
      @name = 'data.yml'

      fileName = base + "/_data/data.yml"
      outFile = File.open( fileName , 'w')

      site.pages.each do |page|
        current = {}
        values = {}
        id = page.url;
        values['title'] = page.data['title']
        current[ id ] = values;
        outFile.write( current.to_yaml );
      end

      site.posts.each do |post|
        current = {}
        values = {}
        values['relations'] = post.relations
        values['title'] = post.title
        current[post.url] = values;
        outFile.write( current.to_yaml );
      end

    end
  end

  class CommonDataGenerator < Generator
    safe true

    def generate(site)
      p 'CommonDataGenerator:generate'

      CommonData.new(site, site.source)

    end
  end

end
