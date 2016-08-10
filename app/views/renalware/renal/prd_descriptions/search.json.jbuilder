json.array! @prd_descriptions do |prd_description|
  json.id     prd_description.id
  json.label  prd_description.to_s
end