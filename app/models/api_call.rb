class ApiCall < ActiveRecord::Base
  attr_accessible :doctor_id, :payer_id, :payer_name, :subscriber_dob, :subscriber_first_name, :subscriber_id, :subscriber_last_name,:patient_contact_no ,:responce
  validate :doctor_id, :payer_id, :payer_name, :subscriber_dob, :subscriber_first_name, :subscriber_id, :subscriber_last_name,:patient_contact_no ,:presence =>true

  def make_api_call(call)
    doctor=User.find(call.doctor_id)
    url ='https://gds.eligibleapi.com/v1/plan/all.json?'+'api_key=Test' +'&payer_id='+(call.payer_id).to_s+'&payer_name='+call.payer_name.to_s+'&subscriber_dob='+call.subscriber_dob.to_s+'&subscriber_id='+call.subscriber_id.to_s+'&subscriber_last_name='+call.subscriber_last_name.to_s+'&subscriber_first_name='+call.subscriber_first_name.to_s+'&service_provider_last_name='+doctor.l_name.to_s+'&service_provider_first_name='+doctor.f_name.to_s+'&service_provider_NPI='+doctor.npi.to_s
    call.responce = Net::HTTP.get(URI.parse(url))
  end
end
