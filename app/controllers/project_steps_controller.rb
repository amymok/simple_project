require 'project_params'
class ProjectStepsController < ApplicationController
  include ProjectParams

  include Wicked::Wizard
  steps :answer_screener, :display_permit, :enter_details, :display_summary
  
  def show
    @project = current_project
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