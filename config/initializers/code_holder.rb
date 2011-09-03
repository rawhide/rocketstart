C = Rocketstart::CodeHolder

code_dir = File.join(Rails.root.to_s, "resources/codes")
Dir.glob("#{code_dir}/*.csv").each do |f|
  name = File.basename(f).chomp(".csv")
  C.load(name.to_sym, :code_dir => code_dir)
end
