![Codeship](https://codeship.com/projects/a91afb80-7d76-0133-4418-6a5cc34fb59d/status?branch=master)

# Spambox
A simple gem that used lib/spam-keywords.json to give a spam score (0-100) based on spammy keywords for any Array, Hash, ActiveRecord- or String object.

## Installation

Add this line to your application's Gemfile:

    gem "spambox", "~> 0.4"

And then execute:

    $ bundle

## Usage

Spambox accepts any `Array`, `Hash`, `ActiveRecord` or `String` object. It basically counts the occurences of suspicious keywords and returns the percentage of words that it doesn't trust.

It's up to you to determine a threshold to treat an object as spam.

Example usage:

```ruby
Spambox.new("Some pretty trustworthy string.").spam_score
# This will return 0 since none of these words occur in spam keywords blacklist.

Spambox.new("Hi, do you want cheap xanax?").spam_score
# This will return 33 since two of the six words are treated as unsafe.
# You can probably guess which ones.
```

## Configuration

By default, Spambox will return a `spam_score` of `100` when the provided object contains any HTML code.

```ruby
Spambox.new("Some pretty trustworthy string, but it does contain html <a href='example.com'>bar</a>.").spam_score
# This will return 100 because it contains HTML.

Spambox.new("Hi, do you want <a href='example.com'>cheap xanax?</a>", { allow_html: true }).spam_score
# This will return 33 since two of the six words are treated as unsafe, but the HTMl is accepted.
```
