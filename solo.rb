#json_attribs     "/home/dan/opscode-chef-repo/node.json"

file_cache_path "/home/dan/chef-solo"

#cookbook_path (File.dirname(__FILE__) + "/cookbooks")
cookbook_path "#{ File.absolute_path(File.dirname(__FILE__)) }/cookbooks"

