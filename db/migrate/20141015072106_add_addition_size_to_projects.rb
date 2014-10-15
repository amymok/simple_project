class AddAdditionSizeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :addition_size, :string
  end
end
