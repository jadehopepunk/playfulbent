require File.dirname(__FILE__) + '/../unit_test_helper'

class UserTest < Test::Unit::TestCase

  def test_is_male
    @gender = Gender.new
    assert_equal false, @gender.is_male?
    @gender.name = 'mAle'
    assert_equal true, @gender.is_male?    
  end
  
  def test_is_female
    @gender = Gender.new
    assert_equal false, @gender.is_female?
    @gender.name = 'femaLE'
    assert_equal true, @gender.is_female?    
  end

  def test_third_person_passive_pronoun
    @gender = Gender.new
    assert_equal 'them', @gender.third_person_passive_pronoun

    @gender.name = 'male'
    assert_equal 'him', @gender.third_person_passive_pronoun

    @gender.name = 'female'
    assert_equal 'her', @gender.third_person_passive_pronoun
  end

  def test_third_person_active_pronoun
    @gender = Gender.new
    assert_equal 'they', @gender.third_person_active_pronoun

    @gender.name = 'male'
    assert_equal 'he', @gender.third_person_active_pronoun

    @gender.name = 'female'
    assert_equal 'she', @gender.third_person_active_pronoun
  end

  def test_third_person_possessive
    @gender = Gender.new
    assert_equal 'their', @gender.third_person_possessive

    @gender.name = 'male'
    assert_equal 'his', @gender.third_person_possessive

    @gender.name = 'female'
    assert_equal 'her', @gender.third_person_possessive
  end

  def test_third_person_self_pronoun
    @gender = Gender.new
    assert_equal 'themself', @gender.third_person_self_pronoun

    @gender.name = 'male'
    assert_equal 'himself', @gender.third_person_self_pronoun

    @gender.name = 'female'
    assert_equal 'herself', @gender.third_person_self_pronoun
  end
  
end
