ActiveAdmin.register User do
  index do
    column :user_name
    column "first Name",:f_name
    column "Last name",:l_name
    column :contact_no
  end
end
