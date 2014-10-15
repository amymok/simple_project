module ProjectParams
  def project_params
   params.require(:project).permit(
    :name, 

    # --Virtual Attributes--
    :selected_addition

    )
 end
end