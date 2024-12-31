# frozen_string_literal: true

require 'rails/railtie'

module ToLLM
  class Railtie < ::Rails::Railtie
    railtie_name :to_llm

    rake_tasks do
      load 'tasks/to_llm.rake'
    end
  end
end
