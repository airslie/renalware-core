module Renalware
  class ZipArchive
    def initialize(file)
      @file = Pathname.new(file)
    end

    def unzip
      # Create a tmp dir and ensure PG has access to it.
      Dir.mktmpdir do |dir|
        FileUtils.chmod("a+rX", dir)
        files = unzip_to_tmp_dir_and_return_pathames_array(dir)
        yield(files)
      end
    end

    def rar_archive?
      output, = Open3.capture2("file", file.to_s)
      output.match?(/RAR/)
    end

    private

    attr_reader :file

    # Zip arguments
    # -o = overwrite if files already there (to avoid unattended)
    # -j = junk (throw away) the path structure in the zip file - this has the risk that
    #      files in separate folders but with the same name could overwrite each other..
    # Unrar arguments
    #  - e extract files
    #  - o+ overwrite existing
    def unzip_to_tmp_dir_and_return_pathames_array(dir)
      zip_realpath = file.realpath
      Dir.chdir(dir) do
        if rar_archive?
          execute("unrar", "e", "-o+", zip_realpath.to_s)
        else
          execute("unzip", "-o", "-j", zip_realpath.to_s)
        end
      end
      Pathname.new(dir).children
    end

    def execute(*cmd)
      success = system(*cmd)
      raise("Command #{cmd.inspect} returned #{$CHILD_STATUS.exitstatus}") unless success
    end
  end
end
