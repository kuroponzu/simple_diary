# Simple Diary

A simple diary application built with Ruby on Rails where users can create, read, update, and delete their personal diary entries with Markdown support.

## Features

- User authentication with Devise
- **Passkey (WebAuthn) support** - Password-free authentication using biometrics
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

## Passkey (WebAuthn) Authentication

### What are Passkeys?

Passkeys are a secure, password-free way to sign in using your device's biometric authentication (fingerprint, Face ID, Touch ID) or PIN. They're more secure than passwords and easier to use.

### Setting up Passkeys

1. Sign in with your email and password
2. Navigate to "Manage Passkeys" from the diary list
3. Click "Add a Passkey"
4. Give your passkey a name (e.g., "My iPhone", "Work Laptop")
5. Follow your device's prompts to complete registration

### Signing in with Passkeys

1. Go to the sign-in page
2. Click "Sign in with Passkey instead"
3. Use your device's biometric authentication or PIN
4. You'll be signed in instantly without entering a password

### Device Compatibility

Passkeys work on:
- iPhone/iPad (iOS 16+) with Face ID or Touch ID
- Android devices (Android 9+) with fingerprint or face unlock
- Windows (Windows 10+) with Windows Hello
- macOS (macOS Ventura+) with Touch ID
- Hardware security keys (YubiKey, etc.)

## Models

### User
- email (required, unique)
- password (required)
- has_many :diaries
- has_many :credentials

### Diary
- title (required)
- content (required, supports Markdown)
- user_id (required)
- belongs_to :user

### Credential (Passkey)
- external_id (required, unique) - WebAuthn credential ID
- public_key (required) - Public key for verification
- sign_count (required) - Counter to prevent replay attacks
- nickname (optional) - User-friendly name for the passkey
- user_id (required)
- belongs_to :user

## Authorization

- All diary actions require authentication
- Users can only access their own diary entries
- Attempting to access another user's diary redirects to the diary list

## Technology Stack

- Ruby on Rails 8.1
- Devise for password-based authentication
- WebAuthn gem for passkey (biometric) authentication
- Redcarpet for Markdown rendering
- RSpec for testing
- FactoryBot for test fixtures
- SQLite3 for database
