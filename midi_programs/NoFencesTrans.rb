require 'midilib/sequence'
require 'midilib/io/seqreader'
require 'midilib/io/seqwriter'

 # Create a new, empty sequence.
 seq = MIDI::Sequence.new()

 # Read the contents of a MIDI file into the sequence.
 File.open('NoFences.mid', 'rb') { | file |
     seq.read(file) { | num_tracks, i |
         # Print something when each track is read.
         puts "read track #{i} of #{num_tracks}"
     }
 }

 # Iterate over every event in every track.
 seq.each { | track |
     track.each { | event |
         # If the event is a note event (note on, note off, or poly
         # pressure) and it is on MIDI channel 5 (channels start at
         # 0, so we use 4), then transpose the event down one octave.
         if event.note? && event.channel == 4
             event.note -= 12
         end
     }
 }

 # Write the sequence to a MIDI file.
 File.open('NoFencesDown.mid', 'wb') { | file | seq.write(file) }
