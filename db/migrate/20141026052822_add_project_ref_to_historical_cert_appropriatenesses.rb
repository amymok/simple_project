class AddProjectRefToHistoricalCertAppropriatenesses < ActiveRecord::Migration
  def change
    add_reference :historical_cert_appropriatenesses, :project, index: true
  end
end
