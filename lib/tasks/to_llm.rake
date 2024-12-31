# frozen_string_literal: true

#
# rails to_llm:extract -ALL
# rails to_llm:extract -MODELS
# rails to_llm:extract -CONTROLLERS
# rails to_llm:extract -VIEWS
# rails to_llm:extract -CONFIG
# rails to_llm:extract -SCHEMA
#


namespace :to_llm do
  desc "Extract code for LLM usage. Usage: rails to_llm:extract [ALL|MODELS|CONTROLLERS|VIEWS|CONFIG|SCHEMA]"
  task :extract, [:type] => :environment do |_t, args|
    # Default to "ALL" if no argument
    extract_type = args[:type]&.upcase || "ALL"
    
    puts "----- to_llm:extract started with type=#{extract_type} -----"

    # Directory where extracted files will be stored
    output_dir = "to_llm"
    FileUtils.mkdir_p(output_dir)

    # Define which directories to process
    directories_to_files = {
      "app/models"      => "models.txt",
      "app/controllers" => "controllers.txt",
      "app/views"       => "views.txt",
      "app/helpers"     => "helpers.txt",
      "config"          => "config.txt", 
      "db/schema.rb"    => "schema.txt"
    }

    # We can filter which directories to process based on the user input
    filter_map = {
      "ALL"         => %w[app/models app/controllers app/views app/helpers config db/schema.rb],
      "MODELS"      => %w[app/models],
      "CONTROLLERS" => %w[app/controllers],
      "VIEWS"       => %w[app/views],
      "CONFIG"      => %w[config],
      "SCHEMA"      => %w[db/schema.rb]
    }

    # Define which extensions you want to extract
    file_extensions = %w[.rb .erb .js .yml]

    directories_to_files.values.each do |filename|
      file_path = File.join(output_dir, filename)
      File.delete(file_path) if File.exist?(file_path)
    end

    def extract_files(dir_path, file_extensions, output_file, output_dir)
      Dir.glob(File.join(dir_path, "**", "*")) do |path|
        next if File.directory?(path)
        next unless file_extensions.include?(File.extname(path))

        File.open(File.join(output_dir, output_file), "a") do |f|
          f.puts "#{path}:"
          f.puts "----------------------------------------------------"
          f.puts File.read(path)
          f.puts "\n"
        end
      end
    end

    (filter_map[extract_type] || []).each do |dir_or_file|
      next unless directories_to_files.key?(dir_or_file)
      output_name = directories_to_files[dir_or_file]

      if File.file?(dir_or_file)
        if File.exist?(dir_or_file)
          File.open(File.join(output_dir, output_name), "a") do |f|
            f.puts "#{dir_or_file}:"
            f.puts "----------------------------------------------------"
            f.puts File.read(dir_or_file)
            f.puts "\n"
          end
        end
      else
        extract_files(dir_or_file, file_extensions, output_name, output_dir)
      end
    end

    puts "----- to_llm:extract finished! Output is located in '#{output_dir}' -----"
  end
end
