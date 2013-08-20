#!/usr/bin/env ruby
#
# A Ruby library for interacting with system-level MIDI services.
#
# == Authors
#
# * Ben Bleything <ben@bleything.net>
#
# == Copyright
#
# Copyright (c) 2008 Ben Bleything
#
# This code released under the terms of the MIT license.
#

module MIDIator
  VERSION = "0.5.1"
end

#####################################################################
###  C O R E   L I B R A R Y   E X T E N S I O N S
#####################################################################
require_relative 'string_extensions'

#####################################################################
###  M I D I A T O R   C O R E
#####################################################################
require_relative 'midiator/driver'
require_relative 'midiator/driver_registry'
require_relative 'midiator/exceptions'
require_relative 'midiator/interface'
require_relative 'midiator/timer'

##########################################################################
### S H O R T C U T   M O D U L E S
##########################################################################
require_relative '../lib/midiator/drums'
require_relative '../lib/midiator/notes'
