class JoyentConfigGenerator < Rails::Generator::Base
  attr_reader :application, :domain, :port

  def initialize(runtime_args, runtime_options={})
    super

    usage if runtime_args.empty?
    @args = runtime_args.dup
    @port = @args.shift
    usage unless port =~ /^\d+$/

    @application = File.basename(File.expand_path(RAILS_ROOT))
    @domain = @args.empty? ? "#{application}.matthewtodd.org" : @args.shift
  end

  def manifest
    record do |m|
      m.template 'Capfile.erb', 'Capfile'
      m.template 'deploy.rb.erb', 'config/deploy.rb'
      m.template 'htaccess.conf.erb', 'public/.htaccess'
    end
  end

  protected

  def banner
    "Usage: #{$0} #{spec.name} PORT [DOMAIN] [options]"
  end
end