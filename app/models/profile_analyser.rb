
# new profile: 0%
# avatar image: 20% (+20%)
# gender: 30% (+10%)
# sexuality: 40% (+10%)
# interests: 55% (+15%)
# kinks: 70% (+15%)
# welcome_text: 85% (+15%)
# at least one gallery image: 100% (+15%)

class ProfileAnalyser
  
  AREAS = {
    :avatar => 20, 
    :gender => 10, 
    :sexuality => 10, 
    :interests => 15, 
    :kinks => 15, 
    :welcome_text => 15, 
    :gallery => 15}
  
  def initialize(profile)
    raise ArgumentError unless profile
    
    @profile = profile
  end
  
  def percent_complete
    result = 0
    AREAS.each { |area, value| result += value if has_achieved?(area) }
    result
  end
  
  def is_complete?
    percent_complete == 100
  end
  
  def next
    AREAS.each { |area, value| return area unless has_achieved?(area) }
    nil
  end
  
  protected
  
    def achieved
      unless @achieved
        @achieved = []
        @achieved << :avatar if @profile.has_avatar?
        @achieved << :gender if @profile.has_gender?
        @achieved << :sexuality if @profile.has_sexuality?
        @achieved << :interests unless @profile.interest_tags.empty?
        @achieved << :kinks unless @profile.kink_tags.empty?
        @achieved << :welcome_text unless @profile.welcome_text.blank?
        @achieved << :gallery unless @profile.display_photos.empty?
      end
      @achieved
    end
    
    def has_achieved?(value)
      achieved.include?(value)
    end
  
end