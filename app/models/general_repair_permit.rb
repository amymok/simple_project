class GeneralRepairPermit < ActiveRecord::Base
  belongs_to :project

  attr_accessor :project_status_to_be_saved

  validates_presence_of :work_summary, :if => :only_if_is_needed_enter_details?


  def only_if_is_needed_enter_details?
    project = Project.find_by_id(project_id)
    puts "^^^^^^project && project.status && project.status.to_s.include?('enter_details') && self.class.is_needed?(project): #{project && project.status && project.status.to_s.include?('enter_details') && self.class.is_needed?(project)}"
    puts "project = #{project}"
    if project
      puts "project.status = #{project.status}"
      if project.status
        puts "project_status_to_be_saved.to_s.include?('enter_details') = #{project_status_to_be_saved.to_s.include?('enter_details')}"
        if project.status.to_s.include?('enter_details') 
          puts "self.class.is_needed?(project) = #{self.class.is_needed?(project)}"
        end
      end
    end
    project && project.status && project_status_to_be_saved.to_s.include?('enter_details') && self.class.is_needed?(project)
  end

  def self.addition_permit_needed?(project)
    if project.addition_size.eql?("lt1000")# && addition_num_story.eql?("1Story")
      return true
    else
      return nil
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
