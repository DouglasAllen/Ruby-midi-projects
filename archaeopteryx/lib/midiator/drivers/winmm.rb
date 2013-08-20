#!/usr/bin/env ruby
#
# The MIDIator driver to interact with Windows Multimedia.  Taken more or less
# directly from Practical Ruby Projects.
#
# NOTE: as yet completely untested.
#
# == Authors
#
# * Topher Cyll
# * Ben Bleything <ben@bleything.net>
#
# == Copyright
#
# Copyright (c) 2008 Topher Cyll
#
# This code released under the terms of the MIT license.
#

require 'dl/import'

require_relative '../../midiator'
require_relative '../driver'
require_relative '../driver_registry'

class MIDIator::Driver::WinMM < MIDIator::Driver # :nodoc:
  module C # :nodoc:
    extend DL::Importer
    dlload 'winmm'

    extern "int midiOutOpen(HMIDIOUT*, int, int, int, int)"
    extern "int midiOutClose(int)"
    extern "int midiOutShortMsg(int, int)"
  end

  def open
    #~ @device = DL.malloc(DL.sizeof('I'))
    @device = DL::CPtr.new(DL.malloc(DL::SIZEOF_INT),DL::SIZEOF_INT)
    C.midiOutOpen(@device, -1, 0, 0, 0)
  end

  def close
    C.midiOutClose(@device.ptr.to_i)
  end

  def message(one, two=0, three=0)
    message = one + (two << 8) + (three << 16)
    C.midiOutShortMsg(@device.ptr.to_i, message)
  end
end
