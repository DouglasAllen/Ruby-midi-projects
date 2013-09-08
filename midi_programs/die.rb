
class Die
  attr_accessor  :current_state, :faces

  class << self
    def roll(*args)      
      new(*args).roll
    end
  end

  def initialize (faces=[1,2,3,4,5,6])
    @faces = faces
    @current_state = self.roll
  end

  def roll
    @current_state = @faces[rand(@faces.length)]
  end

end

puts Die.roll
puts Die.roll
#~ 10.times do
  #~ puts Die.roll
#~ end

#100.times do
#  puts Die.roll
#end
