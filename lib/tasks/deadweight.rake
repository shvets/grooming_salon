namespace :deadweight do
  require 'deadweight'
  
  desc "run Deadweight (requires script/server)"  
  task :run  do  
    dw = Deadweight.new  
    dw.stylesheets = ['/stylesheets/grooming-salon.css']  
    dw.pages = ['/', '/breeds', '/users', '/reports', 
      '/companies', '/groomers', '/pets', '/pet_images', '/pet_owners', '/appointments',
      '/report_engines']  
    puts dw.run  
  end
end
