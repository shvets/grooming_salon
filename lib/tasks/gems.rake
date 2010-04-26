namespace :gems do
  desc "Download and install all gems required by development"
  task :install do
    File.open(File.join(RAILS_ROOT, '.gems'), "r") do |file|
      while (line = file.gets)
        system("gem install #{line}")
      end
    end
  end
end
