require 'test/unit'
require 'chords_minor_flats'

class ChordsminorFlatsTest < Test::Unit::TestCase
  def example_chord1
   	ChordsMinorFlats.new("dbmin")
  end 

  def example_chord2
  	ChordsMinorFlats.new("dbmin")
  end

  def example_chord3
  	ChordsMinorFlats.new("ebmin")
  end

  def example_chord4
    ChordsMinorFlats.new("Abmin")
  end
  
  def example_chord5
    ChordsMinorFlats.new("gbmin")
  end

  def example_chord6
    ChordsMinorFlats.new("bbmin")
  end


  def test_03a_get_chord_for
    assert_equal ["Db", "E", "Ab"] , example_chord1.minor_chord_sharps
  end

  def test_03b_minor_chord_sharps
    assert_equal ["Db", "E", "Ab"] , example_chord2.minor_chord_sharps
  end

  def test_03c_minor_chord_sharps
    assert_equal ["Eb", "Gb", "Bb"] , example_chord3.minor_chord_sharps
  end

  def test_03d_minor_chord_sharps
    assert_equal ["Ab", "B", "Eb"] , example_chord4.minor_chord_sharps
  end

  def test_03e_minor_chord_sharps
    assert_equal ["Gb", "A", "Db"] , example_chord5.minor_chord_sharps
  end

  def test_03f_minor_chord_sharps
    assert_equal ["Bb", "Db", "F"] , example_chord6.minor_chord_sharps
  end

  def test_04_get_notes
    assert_equal "Bb Db F" , example_chord6.get_notes
  end  
end