class AddCoverageStatusToApiCalls < ActiveRecord::Migration
  def change
    add_column :api_calls ,:coverage_status_code ,:string 
  end
end
