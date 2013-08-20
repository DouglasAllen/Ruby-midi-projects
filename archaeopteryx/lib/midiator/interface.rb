#!/usr/bin/env ruby
#
# The main entry point into MIDIator.  Create a MIDIator::Interface object and
# off you go.
#
# == Authors
#
# * Ben Bleything <ben@bleything.net>
#
# == Contributors
#
# * Giles Bowkett
# * Jeremy Voorhis
#
# == Copyright
#
# Copyright (c) 2008 Ben Bleything
#
# This code released under the terms of the MIT license.
#

require_relative '../midiator'
#~ require_relative '../midiator/drivers/winmm'

class MIDIator::Interface
  attr_reader :driver

  ### Automatically select a driver to use
  def autodetect_driver
    driver = case RUBY_PLATFORM
    when /darwin/
      :dls_synth
    when /cygwin/, /mingw/
      :winmm
    when /linux/
      :alsa
    when /java/
      :mmj if Java::java.lang.System.get_property('os.name') == 'Mac OS X'
    else
      raise "No driver is available."
    end

    self.use(driver)
  end


  ### Attempts to load the MIDI system driver called +driver_name+.
  def use( driver_name )
    driver_path = "../midiator/drivers/#{driver_name.to_s}"
    #~ puts driver_path
    begin
      require_relative driver_path
    rescue LoadError => e
      raise LoadError,
        "Could not load driver '#{driver_name}' #{driver_path}."
    end

    # Fix two side-effects of the camelization process... first, change
    # instances of Midi to MIDI.  This fixes the acronym form but doesn't
    # change, for instance, 'timidity'.
    #
    # Second, the require path is midiator/drivers/foo, but the module
    # name is Driver singular, so fix that.
    #~ puts driver_path.camelize
    driver_class = driver_path.camelize.
      gsub( /..::Midi/, 'MIDI' ).
      sub( /::Drivers::/, '::Driver::')

    # special case for the ALSA driver
    driver_class.sub!( /Alsa/, 'ALSA' )

    # special case for the WinMM driver
    driver_class.sub!( /Winmm/, 'WinMM' )

    # special case for the DLSSynth driver
    driver_class.sub!( /Dls/, 'DLS' )

    # this little trick stolen from ActiveSupport.  It looks for a top-
    # level module with the given name.
    @driver = Object.module_eval( "#{driver_class}" ).new
  end


  ### A little shortcut method for playing the given +note+ for the
  ### specified +duration+. If +note+ is an array, all notes in it are
  ### played as a chord.
  def play( note, duration = 0.1, channel = 0, velocity = 100 )
    [note].flatten.each do |n|
      @driver.note_on( n, channel, velocity )
    end
    sleep duration
    [note].flatten.each do |n|
      @driver.note_off( n, channel, velocity )
    end 
  end


  ### Does nothing for +duration+ seconds.
  def rest( duration = 0.1 )
    sleep duration
  end

  #######
  private
  #######

  ### Checks to see if the currently-loaded driver knows how to do +method+ and
  ### passes the message on if so.  Raises an exception (as normal) if not.
  def method_missing( method, *args )
    raise NoMethodError, "Neither MIDIator::Interface nor #{@driver.class} " +
      "has a '#{method}' method." unless @driver.respond_to? method

    return @driver.send( method, *args )
  end

  def start_listening(callback)
     if callback
       # Thread waiting for data to be available
       Thread.abort_on_exception = true
       Thread.new{
       # Fork a new process to read data
       rd,wr = IO.pipe
       if cpid = fork
         wr.close
         at_exit{Process.kill "KILL",cpid}
         loop do
         IO.select([rd])
         @read_data = rd.gets
         next if not @read_data
         @read_data.force_encoding("internal") if RUBY_VERSION.to_f == 1.9
         @read_data = @read_data.gsub(/\\n/,"\n").unpack("CCC") # unescape \\n
         callback.call @read_data
         end
       else
         rd.close
         loop do wr.puts read.gsub(/\n/,"\\\\n") end # escape \n
       end
       }
     end
   end

end
