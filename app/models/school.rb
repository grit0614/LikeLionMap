class School < ActiveRecord::Base

  def self.import(file)
    CSV.read(file.path, :encoding => 'euc-kr', headers: true).each do |row|
      self.create!(row.to_hash)
    end
  end
  
end