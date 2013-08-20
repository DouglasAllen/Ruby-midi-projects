#!/usr/bin/env ruby

require 'helper'

class InputTest < Test::Unit::TestCase

  include MicroMIDI
  include MIDIMessage
  include TestHelper

  def test_thru_listeners
    m = MicroMIDI.message($test_device[:input].open)
    m.thru
    assert_equal(0, m.state.listeners.size)
    assert_equal(1, m.state.thru_listeners.size)
    assert_equal(MIDIEye::Listener, m.state.thru_listeners.first.class)    
  end

  def test_thru_unless
  end
            
end

