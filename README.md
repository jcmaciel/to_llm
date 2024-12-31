# to_llm

[![Gem Version](https://badge.fury.io/rb/to_llm.svg)](https://badge.fury.io/rb/to_llm)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.txt)

**to_llm** is a lightweight Ruby gem that provides a simple set of tasks (or commands) to extract code from a Rails application into text files. This is useful if you want to feed your Rails codebase into a Large Language Model (LLM) or any text-based analysis tool.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Commands](#commands)
- [Configuration](#configuration)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Simple extraction**: Automatically scans your Rails app for files in `app/models`, `app/views`, `app/controllers`, etc.  
- **Configurable**: By default, extracts `.rb`, `.erb`, `.js`, and `.yml` file types, but you can easily adjust.  
- **Rake tasks**: Provides a Rake task (`to_llm:extract`) to keep usage straightforward.  
- **Keeps files separate**: Creates separate `.txt` output files (e.g., `models.txt`, `views.txt`) for easier organization (or combine them, if you prefer).

---

## Installation

Add this line to your Rails project’s `Gemfile`:

```ruby
gem 'to_llm', git: 'https://github.com/jcmaciel/to_llm.git'
```

> Or using RubyGems
> ```ruby
> gem 'to_llm'
> ```

Then execute:

```bash
bundle install
```

---

## Usage

Once installed, the gem integrates with your Rails app via a Railtie that exposes one or more rake tasks. By default, you can run:

```bash
rails to_llm:extract -[ALL|MODELS|CONTROLLERS|VIEWS|CONFIG|SCHEMA]
```

Each of these commands will scan the relevant folders in your Rails app and produce text files containing all the code it finds.

---

## Commands

### 1. `rails to_llm:extract -ALL`

- **Description**: Extracts from all supported Rails directories:
  - `app/models` -> `models.txt`  
  - `app/controllers` -> `controllers.txt`  
  - `app/views` -> `views.txt`  
  - `app/helpers` -> `helpers.txt`  
  - `config` -> `config.txt` (including `config/initializers`)  
  - `db/schema.rb` -> `schema.txt`  
- **Result**: Creates a folder named `to_llm/` with separate `.txt` files.

### 2. `rails to_llm:extract -MODELS`

- **Description**: Extracts only files from `app/models`.
- **Output**: Creates (or overwrites) `to_llm/models.txt`.

### 3. `rails to_llm:extract -CONTROLLERS`

- **Description**: Extracts only from `app/controllers`.
- **Output**: `to_llm/controllers.txt`.

### 4. `rails to_llm:extract -VIEWS`

- **Description**: Extracts from `app/views`.
- **Output**: `to_llm/views.txt`.

### 5. `rails to_llm:extract -CONFIG`

- **Description**: Extracts from `config`, including `config/initializers`.
- **Output**: `to_llm/config.txt`.

### 6. `rails to_llm:extract -SCHEMA`

- **Description**: Extracts only `db/schema.rb`.
- **Output**: `to_llm/schema.txt`.

---

## Configuration

If you want to customize what extensions are included or which directories map to which output files, open the `lib/tasks/to_llm.rake` file (inside this gem) and edit:

```ruby
file_extensions = %w[.rb .erb .js .yml]
directories_to_files = {
  "app/models"      => "models.txt",
  "app/controllers" => "controllers.txt",
  # ...
}
```

This gem is intentionally minimalist. Feel free to fork or override these settings in your local app.

---

## Examples

1. **Extract everything**:
   ```bash
   rails to_llm:extract -ALL
   ```
   Generates:
   ```
   to_llm/
     models.txt
     controllers.txt
     views.txt
     helpers.txt
     config.txt
     schema.txt
   ```

2. **Extract only views**:
   ```bash
   rails to_llm:extract -VIEWS
   ```
   Generates:
   ```
   extracted_files/
     views.txt
   ```
   (Note that any previously existing files in `to_llm` will be untouched or overwritten if they have the same filename.)

---

## Contributing

1. Fork the repo on GitHub.
2. Create a new branch for your feature (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to your branch (`git push origin my-new-feature`).
5. Create a Pull Request on GitHub.

We welcome issues, PRs, and general feedback!

---

## License

This project is available as open source under the terms of the [MIT License](./LICENSE.txt). Feel free to use it in your own projects.
