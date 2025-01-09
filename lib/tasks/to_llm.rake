# lib/tasks/to_llm.rake
# frozen_string_literal: true

namespace :to_llm do
  def run_extraction(extract_type, output_format)
    extract_type  = extract_type&.upcase || "ALL"
    output_format = output_format&.downcase || "txt"

    puts ">> to_llm:extract started with type=#{extract_type}, format=#{output_format}"

    # Directory where extracted files will be stored
    output_dir = "to_llm"
    FileUtils.mkdir_p(output_dir)

    
    directories_to_files = {
      "app/models"      => "models",
      "app/controllers" => "controllers",
      "app/views"       => "views",
      "app/helpers"     => "helpers",
      "app/javascript"  => "javascript",
      "config"          => "config",
      "db/schema.rb"    => "schema"
    }

    
    filter_map = {
      "ALL"         => %w[app/models app/controllers app/views app/helpers app/javascript config db/schema.rb],
      "MODELS"      => %w[app/models],
      "CONTROLLERS" => %w[app/controllers],
      "VIEWS"       => %w[app/views],
      "CONFIG"      => %w[config],
      "SCHEMA"      => %w[db/schema.rb],
      "JAVASCRIPT"  => %w[app/javascript],
      "HELPERS"     => %w[app/helpers]
    }

    # File extensions to extract
    file_extensions = %w[.rb .erb .js .yml .ts .tsx]

    # Clean old outputs
    directories_to_files.values.each do |base_filename|
      path = File.join(output_dir, "#{base_filename}.#{output_format}")
      File.delete(path) if File.exist?(path)
    end

    # Detects a language for syntax highlighting if output_format = md
    def detect_language(ext)
      case ext
      when ".rb"  then "ruby"
      when ".erb" then "erb"
      when ".js"  then "javascript"
      when ".ts", ".tsx" then "typescript"
      when ".yml" then "yaml"
      else "plaintext"
      end
    end

    # Writes file content in either txt or md format
    def write_content(path, content, output_format, output_file)
      if output_format == "md"
        language = detect_language(File.extname(path))
        <<~MARKDOWN
          ## #{path}
          ```#{language}
          #{content}
          ```
        MARKDOWN
      else
        # txt format
        <<~TXT
          #{path}:
          ----------------------------------------------------
          #{content}

        TXT
      end
    end

    # Method to handle directories or single-file extraction
    def extract_content(dir_or_file, file_extensions, output_format, base_output_name, output_dir)
      if File.file?(dir_or_file)
        
        return unless File.exist?(dir_or_file)

        content = File.read(dir_or_file)
        formatted = write_content(dir_or_file, content, output_format, base_output_name)
        File.open(File.join(output_dir, "#{base_output_name}.#{output_format}"), "a") do |f|
          f.puts formatted
        end
      else
        
        Dir.glob(File.join(dir_or_file, "**", "*")) do |path|
          next if File.directory?(path)
          next unless file_extensions.include?(File.extname(path))

          content = File.read(path)
          formatted = write_content(path, content, output_format, base_output_name)
          File.open(File.join(output_dir, "#{base_output_name}.#{output_format}"), "a") do |f|
            f.puts formatted
          end
        end
      end
    end

    
    (filter_map[extract_type] || []).each do |dir_or_file|
      next unless directories_to_files.key?(dir_or_file)

      base_output_name = directories_to_files[dir_or_file]
      extract_content(dir_or_file, file_extensions, output_format, base_output_name, output_dir)
    end

    puts ">> to_llm:extract finished! See '#{output_dir}' for .#{output_format} files."
  end

  
  desc "Extract code into txt or md. Usage: rails \"to_llm:extract[TYPE,FORMAT]\"\n" \
       "Examples:\n" \
       "  rails \"to_llm:extract[ALL,md]\"\n" \
       "  rails \"to_llm:extract[MODELS,txt]\""
  task :extract, [:type_and_format] => :environment do |_t, args|
    if args[:type_and_format].blank?
      # No parameters passed -> show help message
      puts "--------------------------------------------------------------------"
      puts "Usage: rails \"to_llm:extract[TYPE,FORMAT]\""
      puts "Types: ALL, MODELS, CONTROLLERS, VIEWS, CONFIG, SCHEMA, JAVASCRIPT, HELPERS"
      puts "Format: txt or md (Markdown)"
      puts "Examples:"
      puts "  rails \"to_llm:extract[ALL,md]\""
      puts "  rails \"to_llm:extract[MODELS,txt]\""
      puts "--------------------------------------------------------------------"
      next
    end

    # Attempt to parse "TYPE,FORMAT"
    type, format = args[:type_and_format].split(",")

    if format.nil?
      # Old usage
      puts "You are using the old usage: rails to_llm:extract #{type}"
      puts "Please use: rails \"to_llm:extract[#{type},md]\" or rails \"to_llm:extract[#{type},txt]\"."
      
      run_extraction(type, "txt")
    else
      # New usage
      run_extraction(type, format)
    end
  end
end
