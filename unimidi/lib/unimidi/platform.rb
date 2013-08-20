#!/usr/bin/env ruby
#

require 'singleton'

module UniMIDI
  
  class Platform

    include Singleton

    attr_reader :interface
    
    def initialize
      lib = case RUBY_PLATFORM
        when /darwin/ then "ffi-coremidi"
        when /java/ then "midi-jruby"
        when /linux/ then "alsa-rawmidi"
        when /mingw32/ then "midi-winmm"
        #when /win/ then "midi-winmm"
      end
      require_relative("adapter/#{lib}")
      @interface = case RUBY_PLATFORM
        when /darwin/ then CoreMIDIAdapter
        when /java/ then MIDIJRubyAdapter
        when /linux/ then AlsaRawMIDIAdapter
        when /mingw32/ then MIDIWinMMAdapter
        #when /win/ then MIDIWinMMAdapter
      end
    end

  end

end

