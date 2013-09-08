# Start looking for MIDI module classes in the directory above this one.
# This forces us to use the local copy, even if there is a previously
# installed version out there somewhere.
#$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')
#require 'midilib/io/seqreader'
require 'midilib/sequence'
#require 'midilib/consts'
#require 'midilib/event'
#require 'midilib/utils'
#include MIDI

 # Create a new, empty sequence.
 seq = MIDI::Sequence.new()

 # Read the contents of a MIDI file into the sequence.
 File.open('0brown.mid', 'rb') { | file |
     seq.read(file) { | i, num_tracks |
         # Print something when each track is read.
         @track = [] + i.to_a

         @tracks = num_tracks
     }
     puts "number of tracks = #{@tracks}"
     for i in @track
      puts(i.data_as_bytes)
      puts(i.inspect)
     end
 }
 # Write the sequence to a MIDI file.
 #File.open('my_output_file.mid', 'wb') { | file | seq.write(file) }

