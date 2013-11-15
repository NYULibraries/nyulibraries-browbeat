require File.expand_path("#{File.dirname(__FILE__)}/../core/test_case")
require File.expand_path("#{File.dirname(__FILE__)}/helpers")
module NyuLibraries
  module Rooms
    # Base class for BobCat Testss
    class TestCase < NyuLibraries::Core::TestCase
      @@views = YAML.load_file("#{@@config_path}/rooms_views.yml")
      @@config["rooms"] = ENV["rooms"] unless @@config.key?("rooms")
      include Rooms::Helpers
  
      def setup
        super
        @view = "NYU"
        @rooms = @@config["rooms"]
        @views = @@views
      end
    end
  end
end