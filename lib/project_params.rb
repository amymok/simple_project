module ProjectParams
  def project_params
   params.require(:project).permit(
    :name, 
    :selected_addition, 
    :addition_size,
    :status,
    general_repair_permit_attributes: [ :id,
                                        :addition,
                                        :work_summary,
                                        :project_id],
    historical_cert_appropriateness_attributes: [ :id,
                                                  :addition,
                                                  :work_summary,
                                                  :project_id]
    # Add new permit attributes here
    )
 end
end