# Spambox
A simple gem that uses formbox.es to give a spam score based on spammy keywords for any ActiveRecord- or String object.

## Installation

Add this line to your application's Gemfile:

    gem "spambox"

And then execute:

    $ bundle

## Usage

Spambox accepts any `String` or `ActiveRecord` object. It basically counts the occurences of suspicious keywords
and returns the percentage of words that it doesn't trust.

It's up to you to determine a threshold to treat an object as spam. 

Example usage:

```ruby
Spambox.new("Some pretty trustworthy string.").spam_score
# This will return 0 (%) since none of these words occur in Formbox.es blacklist.

Spambox.new("Hi, do you want cheap drugs?").spam_score
# This will return 33 (%) since two of the six words are treated as unsafe.
# You can probably guess which ones.
```
