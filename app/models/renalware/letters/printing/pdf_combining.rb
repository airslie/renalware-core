# frozen_string_literal: true

require_dependency "renalware/letters"

require "attr_extras"

module Renalware
  module Letters
    module Printing
      # Mixin for PDF combination
      module PdfCombining
        extend ActiveSupport::Concern

        def combine_multiple_pdfs_into_one(dir, output_filepath)
          using_a_temporary_output_file do |tmp_outfile|
            shell_to_ghostscript_to_combine_files_into(tmp_outfile, dir)
            copy_tempfile_to_output_file(tmp_outfile, output_filepath)
          end
        end

        # rubocop:disable Metrics/LineLength
        def shell_to_ghostscript_to_combine_files_into(outfile, dir)
          cmd = "gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=#{outfile.path} -dBATCH #{files.join(' ')}"
          err = Open3.popen3(cmd, chdir: dir.to_s) do |_stdin, _stdout, stderr|
            stderr.read
          end
          raise "Error combining PDFs: #{err}" unless err.empty?
        end
        # rubocop:enable Metrics/LineLength

        def copy_tempfile_to_output_file(tmp_outfile, output_file)
          FileUtils.cp tmp_outfile.path, output_file
          output_file
        end

        def files
          @files ||= []
        end

        def rails_tmp_folder
          Rails.root.join("tmp").to_s
        end

        def in_a_temporary_folder
          Dir.mktmpdir(nil, rails_tmp_folder) do |dir|
            yield Pathname(dir)
            # temp dir removed here!
          end
        end

        # Create a tempfile outside the temp dir as dir will be destroyed when outside block closes.
        def using_a_temporary_output_file
          file = Tempfile.new("pdf_combined", rails_tmp_folder)
          begin
            yield file
          ensure
            file.close
            file.unlink # deletes the temp file
          end
        end
      end
    end
  end
end
