# == Schema Information
# Schema version: 258
#
# Table name: genders
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

class Gender < ActiveRecord::Base
  
  def self.unknown
    NullGender.new
  end
  
  def self.default_options
    result = defaults.collect {|g| [g.name, g.name]}
    result << ['Other', 'other']
  end
  
  def self.defaults
    find(:all, :order => 'id ASC', :limit => 2)
  end
  
  def self.find_or_create_by_name(name)
    find(:first, :conditions => ["name = ?", name]) || Gender.new(:name => name)
  end
  
  def to_s
    name
  end
  
  def is_male?
    name.nil? ? false : name.downcase == 'male'
  end
  
  def is_female?
    name.nil? ? false : name.downcase == 'female'
  end
  
  def third_person_passive_pronoun
    return 'him' if is_male?
    return 'her' if is_female?
    Gender.unknown.third_person_passive_pronoun
  end
  
  def third_person_active_pronoun
    return 'he' if is_male?
    return 'she' if is_female?
    Gender.unknown.third_person_active_pronoun
  end
  
  def third_person_possessive
    return 'his' if is_male?
    return 'her' if is_female?
    Gender.unknown.third_person_possessive
  end
  
  def third_person_self_pronoun
    return 'himself' if is_male?
    return 'herself' if is_female?
    'themself'
  end
  
end
