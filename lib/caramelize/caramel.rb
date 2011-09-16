require 'caramelize/wiki'
require 'caramelize/wikkawiki'
require 'caramelize/redmine_wiki'

# Within this method you can define your own Wiki-Connectors to Wikis not supported by default in this software

# Note, if you want to activate this, you need to uncomment the line below.
def customized_wiki
  
  # This example is a reimplementation of the WikkaWiki-Connector. 
  # To connect to WikkaWiki, I suggest to use the predefined Connector below.
  wiki = Caramelize::Wiki.new(:host => "localhost", :username => "user", :database => "database_name", :password => 'admin_gnihihihi', :syntax => :wikka)
  wiki.instance_eval do
    def read_pages
      sql = "SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;"
      @revisions, @titles = [], []
      results = database.query(sql)
      results.each do |row|
        @titles << row["tag"]
        author = @authors[row["user"]]
        page = Page.new({:id => row["id"],
                            :title =>   row["tag"],
                            :body =>    row["body"],
                            :syntax =>  'wikka',
                            :latest =>  row["latest"] == "Y",
                            :time =>    row["time"],
                            :message => row["note"],
                            :author =>  author,
                            :author_name => row["user"]})
        @revisions << page
      end
      @titles.uniq!
      @revisions
      
    end
  end
  
  wiki
end


# if you want to use one of the preset Wiki-Connectors uncomment the connector 
# and edit the database logins accordingly.
def predefined_wiki
  
  # For connection to a WikkaWiki-Database use this Connector
  #return Caramelize::WikkaWiki.new(:host => "localhost", :username => "root", :database => "wikka")
  
  
  # For connection to a Redmine-Database use this Connector
  return Caramelize::RedmineWiki.new(:host => "localhost", :username => "root", :database => "redmine_development")
end


def input_wiki
  
  # comment and uncomment to easily switch between predefined and costumized Wiki-connectors.
  #return customized_wiki
  
  return predefined_wiki

end