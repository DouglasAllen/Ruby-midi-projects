require_relative 'music'
require_relative 'scales'

count=0

number_notes=8

midi = LiveMIDI.new 

until count > number_notes 

# Channel / Note / Velocity
puts "note" + " "+"#{count+=1}"

midi.note_on(ch=rand(8),note=hindu[rand(hindu.length)],vlc=rand(75)+25)

sleep(1)# = 1 second of time 60 = minute

midi.note_off(ch,note,0)

end

puts "Song Over"