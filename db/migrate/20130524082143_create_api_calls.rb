class CreateApiCalls < ActiveRecord::Migration
  def change
    create_table :api_calls do |t|
      t.string :doctor_id
      t.string :payer_name
      t.string :payer_id
      t.string :subscriber_id
      t.string :subscriber_first_name
      t.string :subscriber_last_name
      t.date :subscriber_dob
      t.integer :patient_contact_no

      t.timestamps
    end
  end
end
