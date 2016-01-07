require 'yaml'
require 'digest'

module Jekyll

  class CommonData
    def initialize(site, base)
      @site = site
      @base = base

      dataPath = base + "/_data"
      postPath = base + "/_posts"

      relations = {}
      properties = {}
      it_properties = {}

      site.pages.each do |page|
        layout = page.data['layout']
        title = page.data['title']
        if( layout == 'people' or layout == 'projects' or layout == 'areas')
          values = {}
          id = page.url;
          values['title'] = title
          if(page.data['based'])
            values['based'] = page.data['based']
          end

          if(page.data['language'] == 'it')
            it_properties[page.url] = values;
          else
            properties[page.url] = values;
          end

          # p page.path + " " + page.url
        end

      end

      site.posts.docs.each do |post|
        values = {}
        values['relations'] = post.data['relations']
        values['title'] = post.data['title']
        values['date'] = post.data['date']
        if(post.path.include? '_posts/2' or post.path.include? '_posts/1')  #only en posts
          relations[post.url] = values
          if(post.path.include? '_posts/2')
            itpath = post.path.sub! '_posts/2', '_posts/it/2'
          else
            itpath = post.path.sub! '_posts/1', '_posts/it/1'
          end
          itexist = File.exist?(itpath);
          p itpath + " exist? " + itexist.to_s
          if not itexist
            itfile = File.open( itpath , 'w')
            itvalues = {}
            itvalues['layout'] = 'post'
            itvalues['permalink'] = '/it' + post.url;
            itvalues['language'] = 'it'
            itvalues['title'] = post.data['title']
            itvalues['date'] = post.data['date']
            itfile.write(itvalues.to_yaml)
            itfile.write("---")
            itfile.write("\n")
            itfile.write("\n")
            itfile.write(post.content)

          end
        end
        # p post.path + " " + post.url
      end

      relationsFile  = File.open( dataPath + "/relations.yml" , 'w')
      relationsFile.write( relations.to_yaml );

      propertiesFile = File.open( dataPath + "/properties.yml" , 'w')
      propertiesFile.write( properties.to_yaml );
      itPropertiesFile = File.open( dataPath + "/it_properties.yml" , 'w')
      itPropertiesFile.write( it_properties.to_yaml );


    end
  end

  class CommonDataGenerator < Generator
    safe false

    def generate(site)
      CommonData.new(site, site.source)
    end
  end

end
