require 'project_params'
class ProjectStepsController < ApplicationController
  include ProjectParams

  include Wicked::Wizard
  steps :answer_screener, :display_permit, :enter_details, :display_summary
  
  def show
    @project = current_project

    case step
    when :display_permit
      @permit_needs = @project.get_permit_needed_info
      # if @project.selected_addition
      #   @project.update(:general_repair_permit_attributes => {:addition => @project.selected_addition})
      # end

      # should have some indicators on how to display permit info and which one needs which permits
      # can we check which relationship is there?
      # @permit_needs = @project.get_require_permits_for_subprojects
      # @subjprojects_permit_needed = Project.get_subprojects_permit_needed(@permit_needs)
      # @subjprojects_permit_not_needed = Project.get_subprojects_permit_not_needed(@permit_needs)
      # @subjprojects_further_assistance_needed = Project.get_subprojects_further_assistance_needed(@permit_needs)
    end
    render_wizard
  end

  def update
    @project = current_project
    @project.update_attributes(project_params)
    if @project.errors.any?
      # render the same step
      # @TODO: What does this mean?
      render_wizard
    else
      # render the next step
      render_wizard(@project)
    end
  end
end