class HistoricalCertAppropriateness < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :work_summary, :if => :only_if_is_needed_enter_details?
  
  def only_if_is_needed_enter_details?
    project = Project.find_by_id(project_id)
    project && project.status && project.status.to_s.include?('enter_details') && self.class.is_needed?(project)
  end

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
