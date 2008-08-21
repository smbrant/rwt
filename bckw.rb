#!/usr/bin/ruby -w
require 'fileutils'
puts `7z a -tzip #{Time.now.strftime("%Y_%m_%d__%H_%M")}__#{File.basename(FileUtils.pwd)}.zip -r -x!nbproject -x!*.zip -x!*.sh* -x!log -x!public\\ext -x!tmp -x!vendor -x!.git`