class HistoricalCertAppropriateness < ActiveRecord::Base
  belongs_to :project

  def self.addition_permit_needed?(project)
    # check whenever there's an addition 
    if project.selected_addition # && addition_num_story.eql?("1Story")
      return true
    else
      return false
    end
  end

  def self.subprojects_needs(project)
    response = {}
    if project.selected_addition
      response[:selected_addition] = self.addition_permit_needed?(project)
      # Add more subprojects
    end
    return response
  end

  def self.is_needed?(project)
    if self.addition_permit_needed?(project) # || self.subproject_permit_needed?(project) (continue to add more subject here)
      return true
    else
      return false
    end
  end

end
