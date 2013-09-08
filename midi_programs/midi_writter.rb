$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')

require 'midilib/sequence'
require 'midilib/consts'
require 'die'
include MIDI

class MidiWriter

  def initialize(instrument=1, filename='midi.mid')
    @filename = filename
    @instrument = instrument
  end

  def write(data)
    seq = Sequence.new()
    track = Track.new(seq)
    seq.tracks << track
    track.events << Tempo.new(Tempo.bpm_to_mpq(180))
    track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')
    track = Track.new(seq)
    seq.tracks << track
    track.name = 'My New Track'
    track.events << Controller.new(0, CC_VOLUME, 127)
    track.events << ProgramChange.new(0, @instrument, 0)
    for event in data
      track.events << NoteOnEvent.new(0, event[:note], 127, 0)
      track.events << NoteOffEvent.new(0, event[:note], 127,
          seq.note_to_delta(event[:duration]))
    end
    File.open("#{@filename}", 'wb') { | file |
    	seq.write(file)
    }
  end
end

notes = [0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17,
    19, 21, 23, 24] # two octaves of a major scale
note_die = Die.new([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14])
durations = ['8th','quarter','dotted quarter','half',
    'dotted half','whole']
duration_die = Die.new([0,1,2,3,4,5])
midi_data = []
100.times do
  event = {:note => (30 + notes[note_die.roll]),
      :duration => durations[duration_die.roll]}
  midi_data.push(event)
end
writer = MidiWriter.new(1, "#{@filename}")
writer.write(midi_data)

