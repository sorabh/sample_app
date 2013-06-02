require 'net/http'
class ApiCall < ActiveRecord::Base
  attr_accessible :doctor_id, :patient_contact_no, :payer_id, :payer_name, :subscriber_dob, :subscriber_first_name, :subscriber_id, :subscriber_last_name ,:responce,:coverage_status_code
  validates :doctor_id, :patient_contact_no, :payer_id, :payer_name, :subscriber_dob, :subscriber_first_name, :subscriber_id, :subscriber_last_name, :presence => true
  validates :patient_contact_no ,:numericality => { :only_integer => true } ,length: {is: 10}


  def self.make_api_call(call)
    doctor=User.find(call.doctor_id)
    uri =URI.parse('https://gds.eligibleapi.com/v1/plan/all.json?'+'api_key=Test' +'&payer_id='+(call.payer_id).to_s+'&payer_name='+call.payer_name.to_s+'&subscriber_dob='+call.subscriber_dob.to_s+'&subscriber_id='+call.subscriber_id.to_s+'&subscriber_last_name='+call.subscriber_last_name.to_s+'&subscriber_first_name='+call.subscriber_first_name.to_s+'&service_provider_last_name='+doctor.l_name.to_s+'&service_provider_first_name='+doctor.f_name.to_s+'&service_provider_NPI='+doctor.npi.to_s)
   # call.responce= Net::HTTP.get(URI.parse(url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    status = response.status
    if status ==
    call.responce=response.body
    json_body=JSON.parse(response.body)
    call.coverage_status_code= json_body["coverage_status"]
  end


  def self.to_csv(option ={},id)
    column=["subscriber_first_name","subscriber_last_name","subscriber_id","patient_contact_no","subscriber_dob","payer_name","payer_id","coverage_status_code"]
    CSV.generate(option) do |csv|
      csv << ["Patient First name","Patient Last name","Patient Id","Patient Contact No","Patient DoB","Insurance Company Name","Insurance Company Id","Patient Coverage Status Code"]
      all.each do |api_call|
        csv << api_call.attributes.values_at(*column) if api_call.doctor_id.to_s == id
      end
    end
  end

  def self.import(file,id)
    spreadsheet = open_spreadsheet(file)
    header =["subscriber_first_name","subscriber_last_name","subscriber_id","patient_contact_no","subscriber_dob","payer_name","payer_id","coverage_status_code"]
    column= ["doctor_id","subscriber_first_name","subscriber_last_name","subscriber_id","patient_contact_no","subscriber_dob","payer_name","payer_id","coverage_status_code"]
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row["doctor_id"]=id
      api_call =  new
      api_call.attributes = row.to_hash.slice(*column)
      make_api_call(api_call)
      api_call.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end



  def self.search(search)
    if search
      where('subscriber_first_name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end



end
