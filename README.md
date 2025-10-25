# Simple Diary

A simple diary application built with Ruby on Rails where users can create, read, update, and delete their personal diary entries with Markdown support.

## Features

- User authentication with Devise
- CRUD operations for diary entries
- Markdown support for diary content (using Redcarpet)
- User-specific diary entries (users can only access their own entries)
- Comprehensive test suite with RSpec

## Requirements

- Ruby 3.4.7
- Rails 8.1.0
- SQLite3

## Setup

1. Install dependencies:
```bash
bundle install
```

2. Create and setup the database:
```bash
bundle exec rails db:create
bundle exec rails db:migrate
```

3. Start the Rails server:
```bash
bundle exec rails server
```

4. Visit [http://localhost:3000](http://localhost:3000)

## Running Tests

Run the full test suite:
```bash
bundle exec rspec
```

## Usage

1. Sign up for a new account or sign in
2. Create new diary entries with Markdown formatting
3. View, edit, or delete your diary entries
4. Markdown features supported:
   - **Bold text** with `**text**`
   - *Italic text* with `*text*`
   - Headers with `#`
   - Links, lists, code blocks, and more

## Models

### User
- email (required, unique)
- password (required)
- has_many :diaries

### Diary
- title (required)
- content (required, supports Markdown)
- user_id (required)
- belongs_to :user

## Authorization

- All diary actions require authentication
- Users can only access their own diary entries
- Attempting to access another user's diary redirects to the diary list

## Technology Stack

- Ruby on Rails 8.1
- Devise for authentication
- Redcarpet for Markdown rendering
- RSpec for testing
- FactoryBot for test fixtures
- SQLite3 for database
