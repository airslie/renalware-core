describe Forms::Helpers do
  subject(:helper) do
    Class.new do
      include Forms::Helpers
    end.new
  end

  describe "#open_pdf" do
    it "passes the filename to gio as a single argument" do
      filename = "/tmp/form; not-a-command.pdf"
      allow(Open3).to receive(:capture2).and_return(["", instance_double(Process::Status)])

      helper.open_pdf(filename)

      expect(Open3).to have_received(:capture2).with("gio", "open", filename)
    end
  end
end
