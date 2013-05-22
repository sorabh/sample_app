ActiveAdmin.register ApiCall do
  config.per_page = 10
  index do
    column "Doctor id",:doctor_id
    column :payer_id
    column :payer_name
    column :subscriber_first_name
    column :subscriber_last_name
    column :subscriber_id
    column :patient_contact_no

  end
end

