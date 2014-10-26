class CreateHistoricalCertAppropriatenesses < ActiveRecord::Migration
  def change
    create_table :historical_cert_appropriatenesses do |t|
      t.boolean :addition
      t.text :work_summary

      t.timestamps
    end
  end
end
