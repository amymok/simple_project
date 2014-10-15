class CreateGeneralRepairPermits < ActiveRecord::Migration
  def change
    create_table :general_repair_permits do |t|
      t.boolean :addition
      t.text :work_summary

      t.timestamps
    end
  end
end
