require_relative 'music'

midi = LiveMIDI.new 

  (27..87).each do |n|
    midi.play(9, n, 0.25, 127)
  end
