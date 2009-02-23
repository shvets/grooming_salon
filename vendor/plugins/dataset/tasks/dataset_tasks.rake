namespace :db do
	namespace :dataset do
		DATASET_DIR = 'db/dataset'
		SQL_FILE_NAME = 'dataset.sql'

		# this must contain the Session and any other models you wish to ignore
		MODELS_TO_IGNORE = ["CGI::Session::ActiveRecordStore::Session"]

		desc "Load a dataset into the current environment's database from #{DATASET_DIR}. Specify DATASET=x to use #{DATASET_DIR}/x instead."
		task :load_fixtures => 'db:schema:load' do
			require 'active_record/fixtures'
			path = dataset_path
			start_time = Time.now

			puts "Loading dataset to #{RAILS_ENV}"
			keep_quiet = ENV['DBLOAD_QUIET'].to_s.dup == "true"

			fixtures_to_ignore = ENV['IGNORE'] ? ENV['IGNORE'].split(',') : []

			ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
			Dir.glob(path + '/*.yml').each do |fixture_file|
				fixture_name = File.basename(fixture_file, '.*')
				next if fixtures_to_ignore.include?(fixture_name)
				puts "Loading fixture #{fixture_file.to_s}" unless keep_quiet
				Fixtures.create_fixtures(path, fixture_name)
			end
			puts "Completed in #{Time.now - start_time} seconds"
		end

		desc "Dump a dataset from the current environment's database into #{DATASET_DIR}. Specify DATASET=x to use #{DATASET_DIR}/x instead. Specify INCLUDE=Model1,Model2,Model3 to dump only certain model classes"
		task :dump_fixtures => :environment do
			require 'dataset'
			start_time = Time.now

			Dir.glob('app/models/*.rb').each { |file| require file } 

			path = dataset_path
			FileUtils.mkdir_p path

			models_to_include = ENV['INCLUDE'] ? ENV['INCLUDE'].split(',') : [] 

			ActiveRecord::Base.send(:subclasses).each do |ar|
				if !MODELS_TO_IGNORE.include?(ar.to_s) && ((models_to_include.empty? ) || models_to_include.include?(ar.to_s))
					puts "Now dumping #{ ar.to_s } to #{path}"
					ar.to_fixture(path)
				end
			end
			puts "Completed in #{Time.now - start_time} seconds"
		end

		desc "Load a SQL dataset into the current environment's database from #{DATASET_DIR}. Specify DATASET=x to use #{DATASET_DIR}/x instead."
		task :load => :environment do
			start_time = Time.now
			puts "Loading dataset from #{sql_file_path} to #{RAILS_ENV}"

			ActiveRecord::Base.establish_connection(RAILS_ENV)
			File.new(sql_file_path).each_line(";\n") do |sql|
				ActiveRecord::Base.connection.execute(sql) unless sql.blank?
			end
			puts "Completed in #{Time.now - start_time} seconds"
		end

		desc "Dump a SQL dataset from the current environment's database into #{DATASET_DIR}/dataset.sql. Specify DATASET=x to use #{DATASET_DIR}/x/dataset.sql instead."
		task :dump => :environment do
			require 'active_record'
			start_time = Time.now
			puts "Dumping dataset to #{sql_file_path}"

			FileUtils.mkdir_p dataset_path
			
			db_config = ActiveRecord::Base.configurations[RAILS_ENV]
			puts "Executing: mysqldump #{db_config['database']} -u #{db_config['username']} -p#{db_config['password']} > #{sql_file_path}"
			puts `mysqldump #{db_config['database']} -u #{db_config['username']} -p#{db_config['password']} > #{sql_file_path}`
			puts "Completed in #{Time.now - start_time} seconds"
		end
		
		desc "Migrate a SQL dataset to the latest schema version.  You may specify a DATASET environment variable. This task always executes in the 'test' environment."
		task :migrate => :environment do
			RAILS_ENV = 'test'
			puts "Running migration on dataset #{sql_file_path}"
			
			puts ". . . purging test database"
			Rake::Task['db:test:purge'].invoke
			
			puts ". . . loading test database"
			Rake::Task['db:dataset:load'].invoke
			
			puts ". . . migrating test database"
			Rake::Task['db:migrate'].invoke
			
			puts ". . . dumping migrated test database"
			Rake::Task['db:dataset:dump'].invoke
			
			puts "Finished migration of dataset #{sql_file_path}"
		end

		desc "Cleans up all dataset information in #{DATASET_DIR}. Specify DATASET=x and the entire #{DATASET_DIR}/x directory will be deleted."
		task :clobber => :environment do
			path = dataset_path
			Dir.glob(path + '/*.yml').each do |file|
				puts "Deleting #{file.to_s}"
				File.delete file
			end

			if path !~ /dataset$/
				puts "Deleting directory #{path}"
				Dir.rmdir path
			end
			puts "Done"
		end

		private
		def dataset_path
			DATASET_DIR + (ENV['DATASET'] ? "/#{ENV['DATASET']}" : "")
		end
		
		def sql_file_path
			dataset_path + '/' + SQL_FILE_NAME
		end
	end
end


