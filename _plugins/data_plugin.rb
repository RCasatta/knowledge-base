require 'yaml'

module Jekyll

  class CommonData
    def initialize(site, base)
      @site = site
      @base = base

      # p "initialize"

      dataPath = base + "/_data"
      relationsFile = File.open( dataPath + "/relations.yml" , 'w')
      relations = {}
      propertiesFile    = File.open( dataPath + "/properties.yml" , 'w')
      properties = {}

      site.pages.each do |page|
        layout = page.data['layout']
        title = page.data['title']
        if( layout == 'people' or layout == 'projects' or layout == 'areas')
          values = {}
          id = page.url;
          values['title'] = title
          properties[id] = values
        end
      end
      propertiesFile.write( properties.to_yaml );

      site.posts.docs.each do |post|
        values = {}
        values['relations'] = post.data['relations']
        values['title'] = post.data['title']
        values['date'] = post.data['date']
        relations[post.url] = values;
      end
      relationsFile.write( relations.to_yaml );

    end
  end

  class CommonDataGenerator < Generator
    safe false

    def generate(site)
      CommonData.new(site, site.source)
    end
  end

end
