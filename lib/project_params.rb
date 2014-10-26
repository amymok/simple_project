module ProjectParams
  def project_params
   params.require(:project).permit(
    :name, 
    :selected_addition, 
    :addition_size,
    general_repair_permit_attributes: [ :id,
                                        :addition,
                                        :work_summary,
                                        :project_id],
    historical_cert_appropriateness_attributes: [ :id,
                                                  :addition,
                                                  :work_summary,
                                                  :project_id]

    )
 end
end