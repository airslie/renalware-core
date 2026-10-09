module Renalware
  describe ZipArchive do
    describe "#unzip" do
      context "when the zip file contains files" do
        it "yields a hash of pathnames keyed by basename" do
          expect { |block|
            described_class.new(file_fixture("simple.zip")).unzip(&block)
          }.to yield_with_args([Pathname, Pathname])
        end

        it "handles shell metacharacters in the archive path" do
          Dir.mktmpdir do |dir|
            archive = Pathname(dir).join("simple; archive.zip")
            FileUtils.cp(file_fixture("simple.zip"), archive)

            expect { |block|
              described_class.new(archive).unzip(&block)
            }.to yield_with_args([Pathname, Pathname])
          end
        end
      end

      # context "when the zip file is in the rar format and has 2 files" do
      #   it "yields a hash of pathnames keyed by basename" do
      #     expect { |block|
      #       described_class.new(file_fixture("simple_rar.zip")).unzip(&block)
      #     }.to yield_with_args([Pathname, Pathname])
      #   end
      # end
    end
  end
end
