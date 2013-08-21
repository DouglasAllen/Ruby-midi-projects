require 'test/unit'
require 'chords_minor_sharps'

class ChordsMinorSharpsTest < Test::Unit::TestCase
  def example_chord1
   	ChordsMinorSharps.new("cmin")
  end 

  def example_chord2
  	ChordsMinorSharps.new("dmin")
  end

  def example_chord3
  	ChordsMinorSharps.new("d#min")
  end

  def example_chord4
    ChordsMinorSharps.new("A#min")
  end
  
  def example_chord5
    ChordsMinorSharps.new("g#min")
  end

  def example_chord6
    ChordsMinorSharps.new("f#min")
  end


  def test_03a_get_chord_for
    assert_equal ["C", "D#", "G"] , example_chord1.minor_chord_sharps
  end

  def test_03b_minor_chord_sharps
    assert_equal ["D", "F", "A"] , example_chord2.minor_chord_sharps
  end

  def test_03c_minor_chord_sharps
    assert_equal ["D#", "F#", "A#"] , example_chord3.minor_chord_sharps
  end

  def test_03d_minor_chord_sharps
    assert_equal ["A#", "C#", "F"] , example_chord4.minor_chord_sharps
  end

  def test_03e_minor_chord_sharps
    assert_equal ["G#", "B", "D#"] , example_chord5.minor_chord_sharps
  end

  def test_03f_minor_chord_sharps
    assert_equal ["F#", "A", "C#"] , example_chord6.minor_chord_sharps
  end

  def test_04_get_notes
    assert_equal "F# A C#" , example_chord6.get_notes
  end  
end