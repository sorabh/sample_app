class ApiCall < ActiveRecord::Base
  attr_accessible :doctor_id, :payer_id, :payer_name, :subscriber_dob, :subscriber_first_name, :subscriber_id, :subscriber_last_name,:patient_contact_no
end
