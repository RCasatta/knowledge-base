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
        fullpath = base + "/" + page.path
        if( layout == 'people' or layout == 'projects' or layout == 'areas' or layout == 'default' or layout == 'page')
          values = {}
          id = page.url;
          values['title'] = title
          if(page.data['based'])
            values['based'] = page.data['based']
          end
          if(page.data['born'])
            values['born'] = page.data['born']
          end

          if( fullpath.include? '/it/')  #only it page
            # p page.path + " INCLUDE /it/"
            it_properties[page.url] = values;
          else
            # p page.path + " do not include /it/"

            properties[page.url] = values;

            itpath = base + '/it/' + page.path
            itexist = File.exists?(itpath);
            # p itpath + " exist? " + itexist.to_s

            if not itexist
              itfile = File.open( itpath , 'w')
              itvalues = {}
              itvalues['layout'] = layout
              itvalues['permalink'] = '/it' + page.url;
              itvalues['language'] = 'it'
              itvalues['title'] = title
              itfile.write(itvalues.to_yaml)
              itfile.write("---")
              itfile.write("\n")
              itfile.write("\n")
              itfile.write(page.content)
              itfile.close
              # google translate https://gist.github.com/kirs/1462329
            end
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
          # p itpath + " exist? " + itexist.to_s
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
            itfile.close

          end
        end
        # p post.path + " " + post.url
      end

      sha256 = Digest::SHA256.new

      #Consider create a function idiot, you are repeating same code 3 times
      relationsPath = dataPath + "/relations.yml"
      relationsData = relations.to_yaml
      dataSha256 = sha256.hexdigest relationsData
      file = File.open(relationsPath, "rb")
      contents = file.read
      file.close
      contentsSha256 = sha256.hexdigest contents

      if(contentsSha256 != dataSha256 )
        p "relations differ, writing..."
        relationsFile  = File.open( relationsPath , 'w')
        relationsFile.write( relationsData )
        relationsFile.close
      end

      propertiesPath = dataPath + "/properties.yml"
      propertiesData = properties.to_yaml
      pDataSha256 = sha256.hexdigest propertiesData
      file = File.open(propertiesPath, "rb")
      contents = file.read
      file.close
      pContSha256 = sha256.hexdigest contents

      if(pDataSha256 != pContSha256)
        p "properties differ, writing..."
        propertiesFile = File.open( propertiesPath , 'w')
        propertiesFile.write( propertiesData )
        propertiesFile.close
      end


      itPropertiesPath = dataPath + "/it_properties.yml"
      itPropertiesData = it_properties.to_yaml
      itPDataSha256 = sha256.hexdigest itPropertiesData
      file = File.open(itPropertiesPath, "rb")
      contents = file.read
      file.close
      itPContSha256 = sha256.hexdigest contents
      if(itPDataSha256 != itPContSha256)
        p "it properties differ, writing..."
        itPropertiesFile = File.open( itPropertiesPath , 'w')
        itPropertiesFile.write( itPropertiesData )
        itPropertiesFile.close
      end

    end
  end

  class CommonDataGenerator < Generator
    safe false

    def generate(site)
      CommonData.new(site, site.source)
    end
  end

end
