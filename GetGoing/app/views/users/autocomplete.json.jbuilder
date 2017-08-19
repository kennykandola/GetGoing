json.array! @users do |user|
  json.email user.email
  json.name user.full_name
end
