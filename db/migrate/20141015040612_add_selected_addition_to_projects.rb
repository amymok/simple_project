class AddSelectedAdditionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :selected_addition, :boolean
  end
end
