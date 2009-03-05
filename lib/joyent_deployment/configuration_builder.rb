module JoyentDeployment
  class ConfigurationBuilder
    def initialize(filename, environment, ui = Capistrano::CLI.ui)
      @filename      = filename
      @environment   = environment
      @ui            = ui
      @configuration = {}
    end

    def gather(defaults)
      say("Building #{@filename}:", :bold)
      say("#{@environment}:", :blue)
      defaults.keys.sort.each { |key| @configuration[key] = ask("  #{key}:", defaults[key], :blue) }
    end

    def confirm
      say('Please review your choices:', :bold)
      say(sanitized_result.to_yaml, :blue)

      if agree('Do these look okay to you?')
        say('Thanks for your help. Proceeding...')
      else
        gather(@configuration)
        confirm
      end
    end

    def result
      { @environment => @configuration }
    end

    def sanitized_result
      { @environment => sanitize(@configuration) }
    end

    private

    def sanitize(hash)
      result = {}
      hash.each { |key, value| result[key] = ((key =~ /password/) ? '********' : value) }
      result
    end

    def say(string, *colors)
      @ui.say(@ui.color(string, *colors))
    end

    def ask(string, default, *colors)
      @ui.ask(@ui.color(string, *colors).concat(' ')) do |question|
        if string =~ /password/
          question.echo = false
        else
          question.default = default
        end
      end
    end

    def agree(string, *colors)
      @ui.ask(@ui.color("#{string} [Yn]", *colors).concat(' ')) do |question|
        question.answer_type = lambda { |answer| answer == 'y' || answer == '' }
        question.case = :downcase
      end
    end
  end
end
