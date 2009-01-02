require 'fileutils'

dir = File.dirname(__FILE__)
FileUtils.copy(dir + "/lib/rules.rb", dir + "/../../../config/consent.rb")

