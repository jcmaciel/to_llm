# to_llm

[![Gem Version](https://badge.fury.io/rb/to_llm.svg)](https://badge.fury.io/rb/to_llm)

**to_llm** is a lightweight Ruby gem that allows you to extract code from your Rails application into text files. It’s especially handy if you want to feed your Rails codebase into a Large Language Model (LLM) or any text-based analysis tool.

## Features

- **Simple extraction**: Automatically scans core Rails directories (`app/models`, `app/controllers`, `app/views`, etc.).
- **Configurable**: Extracts `.rb`, `.erb`, `.js`, `.yml`, `.ts`, and `.tsx` by default; easy to adjust.
- **Rake tasks**: Single entry point for extracting everything or selective directories.
- **Flexible formats**: Outputs to `.txt` or `.md`.

## Installation

Add to your `Gemfile`:

```ruby
gem 'to_llm'
```
And then:

```bash
bundle install
```

*(Alternatively, you can point `gem 'to_llm', git: 'https://github.com/jcmaciel/to_llm.git'` to the GitHub repo.)*

## Usage

With **v0.1.3**, you can run the following commands inside your Rails app:

```bash
rails "to_llm:extract[TYPE,FORMAT]"
```

Where:
- **TYPE** can be `ALL`, `MODELS`, `CONTROLLERS`, `VIEWS`, `CONFIG`, `SCHEMA`, `JAVASCRIPT`, `HELPERS`.
- **FORMAT** can be `txt` or `md`.

**Examples**:

1. Extract *everything* to Markdown:
   ```bash
   rails "to_llm:extract[ALL,md]"
   ```
2. Extract only models to plain text:
   ```bash
   rails "to_llm:extract[MODELS,txt]"
   ```
3. If you omit the second parameter, it defaults to `.txt` (old usage triggers a warning but still works).

## Examples

- **Extract everything**:
  ```bash
  rails "to_llm:extract[ALL,md]"
  ```
  Produces a `to_llm/` folder with separate `.md` files (e.g., `models.md`, `views.md`, etc.).

- **Extract only controllers**:
  ```bash
  rails "to_llm:extract[CONTROLLERS,txt]"
  ```
  Creates/overwrites `to_llm/controllers.txt`.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to your branch (`git push origin my-new-feature`).
5. Open a Pull Request on GitHub.

Feedback, issues, and PRs are always welcome!