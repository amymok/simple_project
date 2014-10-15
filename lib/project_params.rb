module ProjectParams
  def project_params
   params.require(:project).permit(
    :name, 

    # --Virtual Attributes--
    :selected_addition, 
    general_repair_permit_attributes: [ :id,
                                        :addition,
                                        :work_summary,
                                        :project_id]

    )
 end
end