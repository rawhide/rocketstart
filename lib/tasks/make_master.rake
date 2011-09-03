desc "sync privacymark.jp company list."
task :make_master => :environment do
  Master::OfficialCompany::sync
end

