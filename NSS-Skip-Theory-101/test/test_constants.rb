require 'test/unit'
require 'constants'

class ConstantsTest < Test::Unit::TestCase
  def test_01a_sharps_constants_is_array
    assert_equal true , SHARPS.kind_of?(Array)
  end

  def test_01b_flats_constants_is_array
    assert_equal true , FLATS.kind_of?(Array)
  end

  def test_01c_SHARPS_end_of_array_is_nil
    assert_equal nil , SHARPS[24]
  end

  def test_01c_FLATS_end_of_array_is_nil
    assert_equal nil , FLATS[24]
  end

  def test_02a_first_shot_at_a_chord
  	cmaj = "#{SHARPS[0]}, #{SHARPS[4]}, #{SHARPS[7]}"
  	assert_equal "C, E, G" , cmaj
  end

  def test_02b_second_shot_at_a_chord
  	dmin = "#{SHARPS[2]}, #{SHARPS[5]}, #{SHARPS[9]}"
  	assert_equal "D, F, A" , dmin
  end

  def test_03a_first_shot_at_a_scale
  	cmaj_scale = "#{SHARPS[0]}, #{SHARPS[2]}, #{SHARPS[4]}, #{SHARPS[5]}, #{SHARPS[7]}, #{SHARPS[9]}, #{SHARPS[11]}"
  	assert_equal "C, D, E, F, G, A, B" , cmaj_scale
  end

  def test_03b_scale_using_FLATS
  	db_scale = "#{FLATS[1]}, #{FLATS[3]}, #{FLATS[5]}, #{FLATS[6]}, #{FLATS[8]}, #{FLATS[10]}, #{FLATS[0]}"
  	assert_equal "Db, Eb, F, Gb, Ab, Bb, C"	 , db_scale
  end
end
