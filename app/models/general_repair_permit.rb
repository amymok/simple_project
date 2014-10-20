class GeneralRepairPermit < ActiveRecord::Base
  belongs_to :project

  def self.addition_permit_needed?(project)
    if project.addition_size.eql?("lt1000")# && addition_num_story.eql?("1Story")
      return true
    else
      return nil
    end
  end

  def self.is_needed?(project)
    response = {}
    if project.selected_addition
      response[:selected_addition] = self.addition_permit_needed?(project)
    end
    return response
  end

end
