# == Schema Information
#
# Table name: logged_render_times
#
#  id                 :integer(4)      not null, primary key
#  controller_name    :string(255)
#  action_name        :string(255)
#  visit_count        :integer(4)
#  average            :float
#  min                :float
#  max                :float
#  standard_deviation :float
#  is_total           :boolean(1)
#  created_on         :date
#

class LoggedRenderTime < ActiveRecord::Base

  def combined_name=(value)
    self.controller_name, self.action_name = value.split('#')
  end
  
  def combined_name
    is_total ? 'ALL' : "#{controller_name}##{action_name}"
  end

end
