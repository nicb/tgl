#
# $Id: tex_controller.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/active_controller'
require 'yaml'
require 'csv'

module TexController

  class NoRenderKeyError < ActiveController::ActiveControllerError
  end

  class TexFileError < ActiveController::ActiveControllerError
    attr_reader :filename

    def initialize(message)
      super(message)
    end
  end

  class NoTexFileError < TexFileError

    def initialize(filename)
      super("#{filename} does not exist")
    end

  end

  class TexFileNotWritableError < TexFileError

    def initialize(filename)
      super("#{filename} is not writable")
    end

  end

  class Base < ActiveController::Base
    
  private

    EXTENSION_MAP = { :tex => '.tex', :yaml => '.yml', :csv => '.csv', :pic => '.pic' }
    COMMENT_TAG = { :tex => '%', :yaml => '#', :csv => '', :pic => '.\\"' }

  protected

    def template_filename(name, tag)
      File.join(Environment::views_dir, name + EXTENSION_MAP[tag] + '.erb')
    end

    def output_filepath(path, filename)
      File.join(path, File.basename(filename))
    end

    def output_filename(name, tag)
      output_filepath(Environment.output_dir, name + EXTENSION_MAP[tag])
    end

    def print_header(fh, filename, tag)
      name = File.basename(filename)
      comment_tag = COMMENT_TAG[tag]
      fh.puts("#{comment_tag}\n#{comment_tag} DO NOT EDIT!\n#{comment_tag} This file was produced automagically from the #{name} template\n#{comment_tag} Any editing will be overwritten\n#{comment_tag}")
    end

    def check_template_file(name, tag)
      template = template_filename(name, tag)
      raise NoTexFileError.new(template) unless File.exists?(template)
      return template
    end

    def check_output_file(name, tag)
      output = output_filename(name, tag)
      if File.exists?(output)
        raise TexFileNotWritableError.new(output) unless File.writable?(output)
      end
      return output
    end

    def open_io(tname, oname, tag)
      template = check_template_file(tname, tag)
      output = check_output_file(oname, tag)
      fr = File.open(template, 'r')
      fw = File.open(output, 'w')
      return [fr, fw, template]
    end

    def close_io(fr, fw)
      fr.close
      fw.close
    end

    def erb_rendering(fr, fw, template, tag)
      rtex = ERB.new(fr.read, nil, '-')
      print_header(fw, template, tag)
      fw.puts(rtex.result(get_binding))
    end

    def template_rendering(template, output, tag)
      (fr, fw, template) = open_io(template, output, tag)
      erb_rendering(fr, fw, template, tag)
      close_io(fr, fw)
    end

    def common_rendering(options, tag)
      template_rendering(options[tag], options[tag], tag)
    end

    def tex_rendering(options)
      common_rendering(options, :tex)
    end

    def pic_rendering(options)
      common_rendering(options, :pic)
    end

    def yaml_rendering(options)
      output = check_output_file(options[:yaml], :yaml)
      fw = File.open(output, 'w')
      fw.write(YAML.dump(options[:collection]))
      fw.close()
    end

    def csv_rendering(options)
      output = check_output_file(options[:csv], :csv)
      data = options[:collection]
      writer = CSV.open(output, 'w')
      data.each { |line| writer << line }
      writer.close
    end

	public
	
	  def render(options = {})
      if options.has_key?(:tex)
        tex_rendering(options)
      elsif options.has_key?(:yaml)
        yaml_rendering(options)
      elsif options.has_key?(:csv)
        csv_rendering(options)
      elsif options.has_key?(:pic)
        pic_rendering(options)
      else
        raise NoRenderKeyError
      end
    end

  end

end
