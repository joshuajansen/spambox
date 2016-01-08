require "minitest/autorun"
require "spambox"
require "support/entry_mock"

class TestSpambox < Minitest::Test
  def test_only_spam_words_is_100
    assert_equal Spambox.new("pharmacy").spam_score, 100
  end

  def test_string_with_html_is_100
    assert_equal Spambox.new("<a href='#foo'>").spam_score, 100
  end

  def test_safe_string_with_html_allowed_is_0
    assert_equal Spambox.new("<a href='#foo'>", allow_html: true).spam_score, 0
  end

  def test_unsafe_string_with_html_allowed_is_100
    assert_equal Spambox.new("<a href='#foo'>pharmacy</a>", allow_html: true).spam_score, 100
  end

  def test_half_spam_words_is_50
    assert_equal Spambox.new("pharmacy banana").spam_score, 50
  end

  def test_no_spam_words_is_0
    assert_equal Spambox.new("banana pancake").spam_score, 0
  end

  def test_active_record_object_for_spam
    object = EntryMock.new("Billion dollar Pharmacy", "Cheap banana pancakes")
    assert_equal Spambox.new(object).spam_score, 50
  end

  def test_line_breaks_should_pass_spambox
    object = EntryMock.new(
      "joshua@firmhouse.com",
      "Hello, \r\n\r\nI like to get in contact!\r\n
      Looking forward to hearing from you. \r\nBye, \r\n John"
    )

    assert_equal Spambox.new(object).spam_score, 0
  end

  def test_flatten_hash_values_returns_values_from_nested_hash
    hash = {
      form: {
        name: "John",
        email: "john@example.com",
        body: "Hi!",
        address: {
          street: "Mainstreet 1"
        }
      }
    }

    flat_hash = Spambox.new(hash).send(:flatten_hash_values, hash)

    assert_equal flat_hash, ["John", "john@example.com", "Hi!", "Mainstreet 1"]
  end
end
