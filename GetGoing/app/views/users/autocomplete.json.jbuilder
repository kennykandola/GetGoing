json.array! @users do |user|
  json.(user, :email, :first_name, :last_name)
end
