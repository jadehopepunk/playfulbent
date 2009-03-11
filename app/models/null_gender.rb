
class NullGender

  def ==(other)
    !other.nil? && self.name == other.name
  end
  
  def name
    'unspecified'
  end

  def to_s
    name
  end
  
  def is_male?
    false
  end
  
  def is_female?
    false
  end
  
  def third_person_passive_pronoun
    'them'
  end
  
  def third_person_active_pronoun
    'they'
  end
  
  def third_person_possessive
    'their'
  end
  
  def third_person_self_pronoun
    'themself'
  end


end