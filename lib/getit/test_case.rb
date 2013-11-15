require File.expand_path("#{File.dirname(__FILE__)}/../core/test_case")
require File.expand_path("#{File.dirname(__FILE__)}/helpers")
module NyuLibraries
  module GetIt
    # Base class for BobCat Testss
    class TestCase < NyuLibraries::Core::TestCase
      @@views = YAML.load_file("#{@@config_path}/getit_views.yml")
      @@config["getit"] = ENV["getit"] unless @@config.key?("getit")
      include GetIt::Helpers
  
      def setup
        super
        @view = "NYU"
        @tab = "all"
        @getit = @@config["getit"]
        @views = @@views
        
        @views_sans_access = ["NS"]
        @views_sans_login = ["NYHS", "BHS"]
      end
    end
  end
end