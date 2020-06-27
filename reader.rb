count = 1

CSV.foreach("./themotherload.csv", headers: true, return_headers: false) do |row|
  count+=1
  puts row.to_s
  raise "COUNT REACHED" if count > 500_000
end
