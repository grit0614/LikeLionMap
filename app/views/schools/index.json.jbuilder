json.array!(@schools) do |school|
  json.extract! school, :id, :name, :num, :lat, :lng
  json.url school_url(school, format: :json)
end
