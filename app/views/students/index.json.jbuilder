json.array!(@students) do |student|
  json.extract! student, :id, :name, :univ, :image, :assignment, :lecture
  json.url student_url(student, format: :json)
end
