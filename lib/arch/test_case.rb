require File.expand_path("#{File.dirname(__FILE__)}/../core/test_case")
require File.expand_path("#{File.dirname(__FILE__)}/helpers")
module NyuLibraries
  module Arch
    # Base class for BobCat Testss
    class TestCase < NyuLibraries::Core::TestCase
      @@views = YAML.load_file("#{@@config_path}/arch_views.yml")
      @@config["arch"] = ENV["arch"] unless @@config.key?("arch")
      @@config["ns_username"] = ENV["ns_username"] unless @@config.key?("ns_username")
      @@config["ns_password"] = ENV["ns_password"] unless @@config.key?("ns_password")
      include Arch::Helpers

      def setup
        super
        @view = "NYU"
        @tab = "all"
        @arch = @@config["arch"]
        @views = @@views
        @campus = @@config["campus"]
        
        @ns_username = @@config["ns_username"]
        @ns_password = @@config["ns_password"]
      
        @views_sans_eshelf = ["NYHS"]
        @views_sans_access = ["NS"]
        @views_sans_footer = ["NS"]
        @views_sans_login = ["NYHS", "BHS"]
      end
    end
  end
end