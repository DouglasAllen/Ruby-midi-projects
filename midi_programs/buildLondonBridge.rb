#! /usr/bin/env ruby
#
# usage: from_scratch.rb
#
# This script shows you how to create a new sequence from scratch and save it
# to a MIDI file. It creates a file called 'from_scratch.mid'.

# Start looking for MIDI module classes in the directory above this one.
# This forces us to use the local copy, even if there is a previously
# installed version out there somewhere.
$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')

require 'midilib/sequence'
require 'midilib/consts'
include MIDI

@instrument = 32

seq = Sequence.new()

# Create a first track for the sequence. This holds tempo events and stuff
# like that.
track = Track.new(seq)
seq.tracks << track
track.events << Tempo.new(Tempo.bpm_to_mpq(180))
track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

# Create a track to hold the notes. Add it to the sequence.
track = Track.new(seq)
seq.tracks << track

# Give the track a name and an instrument name (optional).
track.name = 'My New Track'
track.instrument = GM_PATCH_NAMES[0]

# Add a volume controller event (optional).
track.events << Controller.new(0, CC_VOLUME, 127)

# Add events to the track: a major scale. Arguments for note on and note off
# constructors are channel, note, velocity, and delta_time. Channel numbers
# start at zero. We use the new Sequence#note_to_delta method to get the
# delta time length of a single quarter note.
track.events << ProgramChange.new(0, @instrument, 0)
sixtnth = seq.note_to_delta('16th')
eigth = seq.note_to_delta('8th')
dotted_quarter = seq.note_to_delta('dotted quarter')
quarter = seq.note_to_delta('quarter')
half = seq.note_to_delta('half')

#[-1, -1, 6, 6, 8, 8, 6].each { | offset |
  track.events << NoteOnEvent.new(0, 60, 127, 0)
  track.events << NoteOffEvent.new(0, 60, 127, dotted_quarter)
  track.events << NoteOnEvent.new(0, 62, 127, 0)
 track.events << NoteOffEvent.new(0, 62, 127, eigth)
  track.events << NoteOnEvent.new(0, 60, 127, 0)
  track.events << NoteOffEvent.new(0, 60, 127, quarter)
  track.events << NoteOnEvent.new(0, 58, 127, 0)
  track.events << NoteOffEvent.new(0, 58, 127, quarter)
  track.events << NoteOnEvent.new(0, 57, 127, 0)
  track.events << NoteOffEvent.new(0, 57, 127, quarter)
  track.events << NoteOnEvent.new(0, 58, 127, 0)
  track.events << NoteOffEvent.new(0, 58, 127, quarter)
  track.events << NoteOnEvent.new(0, 60, 127, 0)
  track.events << NoteOffEvent.new(0, 60, 127, half)
  track.events << NoteOnEvent.new(0, 55, 127, 0)
  track.events << NoteOffEvent.new(0, 55, 127, quarter)
  track.events << NoteOnEvent.new(0, 57, 127, 0)
  track.events << NoteOffEvent.new(0, 57, 127, quarter)
  track.events << NoteOnEvent.new(0, 58, 127, 0)
  track.events << NoteOffEvent.new(0, 58, 127, half)
  track.events << NoteOnEvent.new(0, 57, 127, 0)
  track.events << NoteOffEvent.new(0, 57, 127, quarter)
  track.events << NoteOnEvent.new(0, 58, 127, 0)
  track.events << NoteOffEvent.new(0, 58, 127, quarter)
  track.events << NoteOnEvent.new(0, 60, 127, 0)
  track.events << NoteOffEvent.new(0, 60, 127, half)
  track.events << NoteOnEvent.new(0, 60, 127, 0)
  track.events << NoteOffEvent.new(0, 60, 127, dotted_quarter)
  track.events << NoteOnEvent.new(0, 62, 127, 0)
  track.events << NoteOffEvent.new(0, 62, 127, eigth)
  track.events << NoteOnEvent.new(0, 60, 127, 0)
  track.events << NoteOffEvent.new(0, 60, 127, quarter)
  track.events << NoteOnEvent.new(0, 58, 127, 0)
  track.events << NoteOffEvent.new(0, 58, 127, quarter)
  track.events << NoteOnEvent.new(0, 57, 127, 0)
  track.events << NoteOffEvent.new(0, 57, 127, quarter)
  track.events << NoteOnEvent.new(0, 58, 127, 0)
  track.events << NoteOffEvent.new(0, 58, 127, quarter)
  track.events << NoteOnEvent.new(0, 60, 127, 0)
  track.events << NoteOffEvent.new(0, 60, 127, half)
  track.events << NoteOnEvent.new(0, 55, 127, 0)
  track.events << NoteOffEvent.new(0, 55, 127, half)
  track.events << NoteOnEvent.new(0, 60, 127, 0)
  track.events << NoteOffEvent.new(0, 60, 127, half)
  track.events << NoteOnEvent.new(0, 57, 127, 0)
  track.events << NoteOffEvent.new(0, 57, 127, quarter)
  track.events << NoteOnEvent.new(0, 55, 127, 0)
  track.events << NoteOffEvent.new(0, 55, 127, quarter)
  track.events << NoteOnEvent.new(0, 53, 127, 0)
  track.events << NoteOffEvent.new(0, 53, 127, half)
#}

# Calling recalc_times is not necessary, because that only sets the events'
# start times, which are not written out to the MIDI file. The delta times are
# what get written out.

# track.recalc_times

File.open('LondonBridge.mid', 'wb') { | file |
	seq.write(file)
}
