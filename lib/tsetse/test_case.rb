require File.expand_path("#{File.dirname(__FILE__)}/../core/test_case")
require File.expand_path("#{File.dirname(__FILE__)}/helpers")
module NyuLibraries
  module TseTse
    # Base class for BobCat Testss
    class TestCase < NyuLibraries::Core::TestCase
      @@views = YAML.load_file("#{@@config_path}/tsetse_views.yml")
      @@config["tsetse"] = ENV["tsetse"] unless @@config.key?("tsetse")
      include TseTse::Helpers
  
      def setup
        super
        @view = "NYU"
        @tab = "all"
        @tsetse = @@config["tsetse"]
        @views = @@views
        @views_sans_login = ["NYHS", "BHS"]
      end
    end
  end
end