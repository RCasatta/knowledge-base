
module Jekyll
  Jekyll::Hooks.register :site, :after_reset do |site|
    # p "ciao"
    # code to call after Jekyll renders a post
  end
end
