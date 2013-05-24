class AddResponceToApiCalls < ActiveRecord::Migration
  def change
    add_column :api_calls, :responce, :string
  end
end
