require "json"
require 'open-uri'

class Spambox
  attr_accessor :object
  attr_reader :blacklist

  FORMBOX_BLACKLIST_URL = "https://formbox.es/spam-keywords.json"

  def initialize(object)
    @object = object
    @occurences = 0
    @total_words = 0
    @blacklist = blacklist

    process(object)
  end

  def spam_score
    (@occurences.to_f / @total_words.to_f * 100).round
  end

  private

  def process(object)
    if object.is_a? String
      @occurences = check(object)
      @total_words = object.split.size
    elsif object.is_a? ActiveRecord::Base
      object.class.column_names.each do |column_name|
        attribute = object.send(column_name).to_s
        @occurences += check(attribute)
        @total_words += attribute.split.size
      end
    else
      raise ArgumentError, "SpamFilter only supports String- or ActiveRecord objects, got #{object.class}."
    end
  end

  def check(attribute)
    @blacklist.map { |s|
      attribute.to_s.downcase.scan(s.downcase).count * s.split.size
    }.inject(0, :+)
  end

  def blacklist
    JSON.parse(spam_triggers)
  end

  def spam_triggers
    tmp_filename = "tmp/spam_triggers.json"

    update_blacklist unless File.exists?(tmp_filename) && File.mtime(tmp_filename) > Time.now - (60 * 24 * 7)

    File.read(tmp_filename)
  rescue OpenURI::HTTPError, Errno::ECONNREFUSED
    "{}"
  end

  def update_blacklist
    request = open(FORMBOX_BLACKLIST_URL)

    Dir.mkdir("tmp") unless Dir.exists?("tmp")
    File.open("tmp/spam_triggers.json", 'w') { |f| f.write(request.read) }
  end
end
