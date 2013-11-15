require "open-uri"
require 'timecop'

module NyuLibraries
  module Core
    module Helpers
      module TimeHelpers
        def travel_to time
          Timecop.travel time
          unix_millis = (Time.now.to_f * 1000.0).to_i
          source = open("http://sinonjs.org/releases/sinon-1.7.3.js").read
          source += "sinon.useFakeTimers(#{unix_millis});"
          @driver.script source
        end
      end
    end
  end
end