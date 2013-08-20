#
# Shoes Minesweeper by que/varyform
#

require_relative 'music'
require_relative 'scales'
#~ require 'rubygems'
require_relative 'rb-music-theory'


LEVELS = { :beginner => [9, 9, 10], :intermediate => [16, 16, 40], :expert => [30, 16, 99] }

class Field

  
  CELL_SIZE = 20
  COLORS = %w(#00A #0A0 #A00 #004 #040 #400 #000)
  
  class Cell
    attr_accessor :flag
    def initialize(aflag = false)
      @flag = aflag
    end
  end
  
  class Bomb < Cell
    attr_accessor :exploded
    def initialize(exploded = false)
      @exploded = exploded
    end
  end
  
  class OpenCell < Cell
    attr_accessor :number
    def initialize(bombs_around = 0)
      @number = bombs_around
    end
  end
  
  class MIDICell < Cell 
    attr_reader :action
    def initialize(act = nil)
      @action = act
    end
  end
  
  
  class NoteOffCell < MIDICell
    def initialize
      @action = lambda { all_notes_off }
    end
  end
  
  class EmptyCell < Cell; end
  
  attr_reader :cell_size, :offset
  attr_accessor :midi, :root_note, :scale, :chord, :progression, :duration
  
  def initialize(app, level = :beginner)
    @app = app
    @root_note = Note.new("C")
    @scale = :major_scale
    @chord = :major_chord
    @progression = [1,2,3,4,5,6,7,8]
    @duration = 1
    @midi = LiveMIDI.new
    @channel = rand(8)
    @field = []
    @w, @h, @bombs = LEVELS[level][0], LEVELS[level][1], LEVELS[level][2]
    @h.times { @field << Array.new(@w) { EmptyCell.new } }
    @game_over = false
    @width, @height, @cell_size = @w * CELL_SIZE, @h * CELL_SIZE, CELL_SIZE
    @offset = [(@app.width - @width.to_i) / 2, (@app.height - @height.to_i) / 2]
    #plant_bombs
    layout_cells
    @start_time = Time.now
  end



  def play_chord(midi_object,chord,channel,duration,velocity)
    chord.note_values.each{|note|
        midi_object.note_on(channel,note,velocity)
        }
	  #sustain it a bit
      sleep(duration)
	  #release the chord
      chord.note_values.each{|note|
        midi_object.note_off(channel,note,0)
        }
  end

  def play_arpeggio(midi_object,chord,channel,duration,velocity)
    arpeggio = chord.note_values
    arpeggio = arpeggio - [arpeggio.last] + arpeggio.reverse
    arpeggio.each{|note|
      midi_object.note_on(channel,note,velocity)
      #sustain it a bit
      sleep(duration)
      midi_object.note_off(channel,note,0)
    }
  end

  def test_drive_chord(midi_object,root_note,scale,chord,progression,duration = 1)
chan=@channel
chords = progression.map{|deg|
root_note.send(scale).harmonized_chord(deg,chord)
}    
chords.each{|chord|
play_chord(midi_object,chord,chan,duration,rand(50)+50)
}
  end

  def test_drive_arpeggio(midi_object,root_note,scale,chord,progression,duration = 1)
chan=@channel
chords = progression.map{|deg|
root_note.send(scale).harmonized_chord(deg,chord)
}    
chords.each{|chord|
play_arpeggio(midi_object,chord,chan,duration,rand(50)+50)
}
  end

	  
  def total_time
    @latest_time = Time.now - @start_time unless game_over? || all_found?
    @latest_time
  end
  
  def click!(x, y)
    return unless cell_exists?(x, y)
    #return if has_flag?(x, y)
	self[x,y].action.call if self[x,y].is_a?(MIDICell)
    #return die!(x, y) if bomb?(x, y)
    #open(x, y)
    #discover(x, y) if bombs_around(x, y) == 0
  end  

  def flag!(x, y)
    return unless cell_exists?(x, y)
    self[x, y].flag = !self[x, y].flag unless self[x, y].is_a?(OpenCell)
  end  
  
  def game_over?
    @game_over 
  end
  
  def render_cell(x, y, color = "#AAA", stroke = true)
    @app.stroke "#666" if stroke
    @app.fill color
    @app.rect x*cell_size, y*cell_size, cell_size-1, cell_size-1
    @app.stroke "#BBB" if stroke
    @app.line x*cell_size+1, y*cell_size+1, x*cell_size+cell_size-1, y*cell_size
    @app.line x*cell_size+1, y*cell_size+1, x*cell_size, y*cell_size+cell_size-1
  end
  
  def render_flag(x, y)
    @app.stroke "#000"
    @app.line(x*cell_size+cell_size / 4 + 1, y*cell_size + cell_size / 5, x*cell_size+cell_size / 4 + 1, y*cell_size+cell_size / 5 * 4)
    @app.fill "#A00"
    @app.rect(x*cell_size+cell_size / 4+2, y*cell_size + cell_size / 5, cell_size / 3, cell_size / 4)
  end
  
  def render_bomb(x, y)
    render_cell(x, y)
    if (game_over? or all_found?) then # draw bomb
      if self[x, y].exploded then
        render_cell(x, y, @app.rgb(0xFF, 0, 0, 0.5))
      end
      @app.nostroke
      @app.fill @app.rgb(0, 0, 0, 0.8)
      @app.oval(x*cell_size+3, y*cell_size+3, 13)
      @app.fill "#333"
      @app.oval(x*cell_size+5, y*cell_size+5, 7)
      @app.fill "#AAA"
      @app.oval(x*cell_size+6, y*cell_size+6, 3)
      @app.fill @app.rgb(0, 0, 0, 0.8)
      @app.stroke "#222"
      @app.strokewidth 2
      @app.oval(x*cell_size + cell_size / 2 + 2, y*cell_size + cell_size / 4 - 2, 2)
      @app.oval(x*cell_size + cell_size / 2 + 4, y*cell_size + cell_size / 4 - 2, 1)
      @app.strokewidth 1
    end
  end
  
  def render_number(x, y)
    render_cell(x, y, "#999", false)
    if self[x, y].number != 0 then
      @app.nostroke
      @app.para self[x, y].number.to_s, :left => x*cell_size + 3, :top => y*cell_size - 2, 
        :font => '13px', :stroke => COLORS[self[x, y].number - 1]
    end
  end
  
  
  def all_notes_off
    (0..127).each { |note| @midi.note_off(@channel,note,0) }
  end
  
  
  def paint
    0.upto @h-1 do |y|
      0.upto @w-1 do |x|
        @app.nostroke
        case self[x, y]
			
          when MIDICell then render_cell(x,y)
		  when EmptyCell then render_cell(x, y)
          when Bomb then render_bomb(x, y)
          when OpenCell then render_number(x, y)
        end
        render_flag(x, y) if has_flag?(x, y) && !(game_over? && bomb?(x, y))
      end
    end
  end  

  def bombs_left
    @bombs - @field.flatten.compact.reject {|e| !e.flag }.size
  end  

  def all_found?
    @field.flatten.compact.reject {|e| !e.is_a?(OpenCell) }.size + @bombs == @w*@h
  end  

  def reveal!(x, y)
    return unless cell_exists?(x, y)
    return unless self[x, y].is_a?(Field::OpenCell)
    if flags_around(x, y) >= self[x, y].number then
      (-1..1).each do |v|
        (-1..1).each { |h| click!(x+h, y+v) unless (v==0 && h==0) or has_flag?(x+h, y+v) }
      end
    end      
  end  
  
  private 
  
  def cell_exists?(x, y)
    ((0...@w).include? x) && ((0...@h).include? y)
  end
  
  def has_flag?(x, y)
    return false unless cell_exists?(x, y)
    return self[x, y].flag
  end
  
  def bomb?(x, y)
    cell_exists?(x, y) && (self[x, y].is_a? Bomb)
  end
  
  def can_be_discovered?(x, y)
    return false unless cell_exists?(x, y)
    return false if self[x, y].flag
    cell_exists?(x, y) && (self[x, y].is_a? EmptyCell) && !bomb?(x, y) && (bombs_around(x, y) == 0)
  end  
  
  def open(x, y)
    self[x, y] = OpenCell.new(bombs_around(x, y)) unless (self[x, y].is_a? OpenCell) or has_flag?(x, y)
  end
  
  def neighbors
    (-1..1).each do |col|
      (-1..1).each { |row| yield row, col unless col==0 && row == 0 }
    end  
  end
  
  def discover(x, y)
    open(x, y)
    neighbors do |col, row|
      cx, cy = x+row, y+col
      next unless cell_exists?(cx, cy)
      discover(cx, cy) if can_be_discovered?(cx, cy)
      open(cx, cy)
    end
  end  

  def count_neighbors
    return 0 unless block_given?
    count = 0
    neighbors { |h, v| count += 1 if yield(h, v) }
    count
  end
  
  def bombs_around(x, y)
    count_neighbors { |v, h| bomb?(x+h, y+v) }
  end
  
  def flags_around(x, y)
    count_neighbors { |v, h| has_flag?(x+h, y+v) }
  end
  
  def die!(x, y)
    self[x, y].exploded = true
    @game_over = true
  end

  def plant_bomb(x, y)
    self[x, y].is_a?(EmptyCell) ? self[x, y] = Bomb.new : false
  end
  
  def plant_bombs
    @bombs.times { redo unless plant_bomb(rand(@w), rand(@h)) }
  end

  def layout_cells
	self[0,0] = NoteOffCell.new
	self[1,0] = MIDICell.new( lambda {
		prog = [1,2,3,4,5,6,7,8]
		test_drive_arpeggio(@midi,Note.new("Bb"), :major_scale, :add2_chord, prog, 0.8)
		})		
	self[2,0] = MIDICell.new(lambda{test_drive_arpeggio(@midi,@root_note,@scale,@chord,@progression,@duration)})
	end
  
  def [](*args)
    x, y = args
    raise "Cell #{x}:#{y} does not exists!" unless cell_exists?(x, y)
    @field[y][x]
  end
  
  def []=(*args)
    x, y, v = args
    cell_exists?(x, y) ? @field[y][x] = v : false
  end
end

Shoes.app :width => 730, :height => 550, :title => 'Minesweeper' do
  def render_field
    clear do
      background rgb(50, 50, 90, 0.7)
      flow do
        (0..127).each {|n|
          button Note.name_from_value(n), :width => 20 do
            @field.root_note = Note.new(n)
          end
        }
      end
	
      flow do
        Note.scale_methods.each {|m|
          button m.to_s[0,4], :width => 30 do
            @field.scale = m
          end
        }
      end

	  
      flow do
        Note.chord_methods.each {|m|
          button m.to_s, :width => 30 do
            @field.chord = m
          end
        }
      end
	  
      stack do
        para "Progression"
        @prog = edit_line  do
          @field.progression = eval('[' + @prog.text + ']')
          alert @progression.class
        end
        para "Scale"
        @scale = list_box :items => Note.scale_methods do
          @field.scale = @scale.text
        end
        para "Chord"
          @chord = list_box :items => Note.chord_methods do
            @field.chord = @chord.text
        end
        para "Duration"
        @duration = list_box :items => [0.1,0.2,0.4,0.8,1.0,1.6] do
          @field.duration = @duration.text.to_f
        end		
		
      end
	   	  
      stack do @status = para :stroke => white end
      @field.paint
      para "Left click - open cell, right click - put flag, middle click - reveal empty cells", :top => 420, :left => 0, :stroke => white,  :font => "11px"
    end  
  end
  
  def new_game level
    @field = Field.new self, level
    translate -@old_offset.first, -@old_offset.last unless @old_offset.nil?
    translate @field.offset.first, @field.offset.last
    @old_offset = @field.offset
    render_field
  end
  
  new_game :beginner
  #~ animate(5) { @status.replace "Time: #{@field.total_time.to_i} Bombs left: #{@field.bombs_left}" }
  
  click do |button, x, y|
    next if @field.game_over? || @field.all_found?
    fx, fy = ((x-@field.offset.first) / @field.cell_size).to_i, ((y-@field.offset.last) / @field.cell_size).to_i
    @field.click!(fx, fy) if button == 1
    @field.flag!(fx, fy) if button == 2
    @field.reveal!(fx, fy) if button == 3

    render_field
    alert("Winner!\nTotal time: #{@field.total_time}") if @field.all_found?
    alert("Bang!\nYou loose.") if @field.game_over?
  end
end