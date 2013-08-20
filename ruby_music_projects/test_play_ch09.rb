require_relative 'music'

midi = LiveMIDI.new 
channel = 9
note = 36
inst = 0
duration = 0.25
midi.program_change(channel, inst)
(35..81).each do |n|
  p n
  (0..11).each do |i|
    #~ p n
    note = n
    #~ midi.play(0, n, 0.66, 127) 
    midi.note_on(channel, note, 127)
    sleep(duration)
    midi.note_off(channel, note, 127)   
  end
end