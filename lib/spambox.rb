require "json"
require "open-uri"
require "sanitize"

class Spambox
  FORMBOX_BLACKLIST_URL = "https://formbox.es/spam-keywords.json"

  def initialize(object, options = { allow_html: false })
    @object = object
    @options = options
  end

  def spam_score
    return 100 if @options[:allow_html] == false && contains_html?
    return 0 if (string_length = sanitized_string.split.size.to_f) == 0
    (count_occurences.to_f / string_length * 100).round
  end

  def update_blacklist
    request = open(FORMBOX_BLACKLIST_URL)

    Dir.mkdir("tmp") unless Dir.exist?("tmp")
    File.open("tmp/spam_triggers.json", "w") { |f| f.write(request.read) }
  end

  private

  def sanitized_string
    Sanitize.fragment(flat_string)
  end

  def flat_string
    @flat_string ||= squish(object_to_string)
  end

  def object_to_string
    case @object
    when String
      return @object
    when Array
      return @object.join(" ")
    when Hash
      return flatten_hash_values(h).values.join(" ")
    when ActiveRecord::Base
      return @object.class.column_names.map do |column|
        @object.send(column).to_s
      end.join(" ")
    else
      fail ArgumentError, "SpamFilter only supports Array-,
        String- or ActiveRecord objects, got #{@object.class}."
    end
  end

  def contains_html?
    return true if sanitized_string != flat_string
  end

  def count_occurences
    blacklist.map do |s|
      sanitized_string.downcase.scan(s.downcase).count * s.split.size
    end.inject(0, :+)
  end

  def blacklist
    JSON.parse(spam_triggers)
  end

  def spam_triggers
    tmp_filename = "tmp/spam_triggers.json"

    update_blacklist unless File.exist?(tmp_filename) && File.mtime(tmp_filename) > Time.now - (60 * 24 * 7)

    File.read(tmp_filename)
  rescue OpenURI::HTTPError, Errno::ECONNREFUSED
    "{}"
  end

  def flatten_hash_values(hash)
    return hash if hash.is_a? String
    hash.flat_map { |_, v| [*flatten_hash_values(v)] }
  end

  def squish(string)
    string.gsub(/[[:space:]]+/, ' ').strip
  end
end
