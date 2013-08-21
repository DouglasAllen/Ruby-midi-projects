require 'test/unit'
require 'chords_major_sharps'

class ChordsMajorSharpsTest < Test::Unit::TestCase
  def example_chord1
   	ChordsMajorSharps.new("cmaj")
  end 

  def example_chord2
  	ChordsMajorSharps.new("dmaj")
  end

  def example_chord3
  	ChordsMajorSharps.new("d#maj")
  end

  def example_chord4
    ChordsMajorSharps.new("A#maj")
  end
  
  def example_chord5
    ChordsMajorSharps.new("g#maj")
  end

  def example_chord6
    ChordsMajorSharps.new("f#maj")
  end


  def test_03a_get_chord_for
    assert_equal ["C", "E", "G"] , example_chord1.major_chord_sharps
  end

  def test_03b_major_chord_sharps
    assert_equal ["D", "F#", "A"] , example_chord2.major_chord_sharps
  end

  def test_03c_major_chord_sharps
    assert_equal ["D#", "G", "A#"] , example_chord3.major_chord_sharps
  end

  def test_03d_major_chord_sharps
    assert_equal ["A#", "D", "F"] , example_chord4.major_chord_sharps
  end

  def test_03e_major_chord_sharps
    assert_equal ["G#", "C", "D#"] , example_chord5.major_chord_sharps
  end

  def test_03f_major_chord_sharps
    assert_equal ["F#", "A#", "C#"] , example_chord6.major_chord_sharps
  end

  def test_04_get_notes
    assert_equal "F# A# C#" , example_chord6.get_notes
  end  
end