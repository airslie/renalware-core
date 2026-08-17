module Renalware
  describe ZipArchive do
    def path_to_zipfile(filename)
      Rails.root.join("spec", "fixtures", "files", filename)
    end

    describe "#unzip" do
      context "when the zip file contains files" do
        it "yields a hash of pathnames keyed by basename" do
          expect { |block|
            described_class.new(path_to_zipfile("simple.zip")).unzip(&block)
          }.to yield_with_args([Pathname, Pathname])
        end

        it "handles shell metacharacters in the archive path" do
          Dir.mktmpdir do |dir|
            archive = Pathname(dir).join("simple; archive.zip")
            FileUtils.cp(path_to_zipfile("simple.zip"), archive)

            expect { |block|
              described_class.new(archive).unzip(&block)
            }.to yield_with_args([Pathname, Pathname])
          end
        end
      end

      # context "when the zip file is in the rar format and has 2 files" do
      #   it "yields a hash of pathnames keyed by basename" do
      #     expect { |block|
      #       described_class.new(path_to_zipfile("simple_rar.zip")).unzip(&block)
      #     }.to yield_with_args([Pathname, Pathname])
      #   end
      # end
    end
  end
end
