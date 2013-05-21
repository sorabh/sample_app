class AddPatientContactNoToApiCalls < ActiveRecord::Migration
  def change
    add_column :api_calls, :patient_contact_no, :telephone
  end
end
