require 'test/unit'
require 'chords_major_flats'

class ChordsMajorFlatsTest < Test::Unit::TestCase
  def example_chord1
   	ChordsMajorFlats.new("dbmaj")
  end 

  def example_chord2
  	ChordsMajorFlats.new("dbmaj")
  end

  def example_chord3
  	ChordsMajorFlats.new("ebmaj")
  end

  def example_chord4
    ChordsMajorFlats.new("Abmaj")
  end
  
  def example_chord5
    ChordsMajorFlats.new("gbmaj")
  end

  def example_chord6
    ChordsMajorFlats.new("bbmaj")
  end


  def test_03a_get_chord_for
    assert_equal ["Db", "F", "Ab"] , example_chord1.major_chord_sharps
  end

  def test_03b_major_chord_sharps
    assert_equal ["Db", "F", "Ab"] , example_chord2.major_chord_sharps
  end

  def test_03c_major_chord_sharps
    assert_equal ["Eb", "G", "Bb"] , example_chord3.major_chord_sharps
  end

  def test_03d_major_chord_sharps
    assert_equal ["Ab", "C", "Eb"] , example_chord4.major_chord_sharps
  end

  def test_03e_major_chord_sharps
    assert_equal ["Gb", "Bb", "Db"] , example_chord5.major_chord_sharps
  end

  def test_03f_major_chord_sharps
    assert_equal ["Bb", "D", "F"] , example_chord6.major_chord_sharps
  end

  def test_04_get_notes
    assert_equal "Bb D F" , example_chord6.get_notes
  end  
end