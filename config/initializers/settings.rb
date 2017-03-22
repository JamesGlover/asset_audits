require 'singleton'
class Settings
  attr_accessor :settings
  include Singleton

  class << self
    def respond_to?(method, include_private = false)
      super || instance.respond_to?(method, include_private)
    end

    protected

    def method_missing(method, *args, &block)
      return super unless instance.respond_to?(method)
      instance.send(method, *args, &block)
    end
  end

  def initialize
    filename    = File.join(File.dirname(__FILE__), '..', 'settings', "#{Rails.env}.yml")
    @settings   = YAML.safe_load(eval(ERB.new(File.read(filename)).src, nil, filename))
  end

  def respond_to?(method, include_private = false)
    super || is_settings_query_method?(method) || @settings.key?(setting_key_for(method))
  end

  protected

  def method_missing(method, *args, &block)
    setting_key    = setting_key_for(method)
    setting_exists = @settings.key?(setting_key)

    if is_settings_query_method?(method)
      setting_exists
    elsif setting_exists
      @settings[setting_key]
    else
      super
    end
  end

  private

  def is_settings_query_method?(method)
    method.to_s =~ /\?$/
  end

  def setting_key_for(method)
    method.to_s.match(/^([^\?]+)\??$/)[1]
  end
end

Settings.instance
