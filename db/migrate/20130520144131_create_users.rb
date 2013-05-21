class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :f_name
      t.string :l_name
      t.integer :npi
      t.integer :contact_no
      t.string :hashed_password
      t.string :salt

      t.timestamps
    end
  end
end
