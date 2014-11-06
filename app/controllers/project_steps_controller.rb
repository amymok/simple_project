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

    when :enter_details
      @project.create_needed_permits

    end


    render_wizard
  end

  def update
    @project = current_project

    # Update status so model can perform validation accordingly
    if params[:project] == nil
      params[:project] = {}
    end
    params[:project][:status] = step.to_s
    if params[:project][:general_repair_permit_attributes]
      params[:project][:general_repair_permit_attributes][:project_status_to_be_saved] = step.to_s
    end
    if params[:project][:historical_cert_appropriateness_attributes]
      params[:project][:historical_cert_appropriateness_attributes][:project_status_to_be_saved] = step.to_s
    end
    
    @project.update_attributes(project_params)
    if @project.errors.any?
      render_wizard
    else
      # render the next step
      render_wizard(@project)
    end
  end
end