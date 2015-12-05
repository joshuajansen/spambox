require 'minitest/autorun'
require 'spambox'
require 'support/entry_mock'

class TestSpambox < Minitest::Test
  def test_only_spam_words_is_100
    assert_equal Spambox.new("pharmacy").spam_score, 100
  end

  def test_string_with_html_is_100
    assert_equal Spambox.new("<a href='#foo'>").spam_score, 100
  end

  def test_safe_string_with_html_allowed_is_0
    assert_equal Spambox.new("<a href='#foo'>", { allow_html: true }).spam_score, 0
  end

  def test_unsafe_string_with_html_allowed_is_100
    assert_equal Spambox.new("<a href='#foo'>pharmacy</a>", { allow_html: true }).spam_score, 100
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
end
