require "gpg_encrypt_folder"

describe GpgEncryptFile do
  subject(:encrypt_file) { described_class.new(file:, options:) }

  let(:file) { Pathname("/tmp/patient record.xml") }
  let(:options) do
    GpgOptions.new(
      recipient: "Patient View",
      destination_folder: Pathname("/tmp/encrypted records"),
      public_key_name: "patient-view.asc"
    )
  end
  let(:command) do
    [
      "gpg",
      "--armor",
      "--no-default-keyring",
      "--trust-model",
      "always",
      "--no-random-seed-file",
      "--keyring",
      Rails.root.join("config/gpg/ukrdc_keyring.gpg").to_s,
      "--recipient",
      "Patient View",
      "-o",
      "/tmp/encrypted records/patient record.gpg",
      "--encrypt",
      "/tmp/patient record.xml"
    ]
  end
  let(:gpg_command) { instance_double(GpgCommand, to_a: command) }

  before do
    allow(GpgCommand).to receive(:new).with(file:, options:).and_return(gpg_command)
  end

  it "passes each GPG option as a separate subprocess argument" do
    allow(Open3).to receive(:popen3).with(*command).and_yield(nil, nil, StringIO.new(""))

    encrypt_file.call

    expect(Open3).to have_received(:popen3).with(*command)
  end

  it "raises when GPG writes an error" do
    allow(Open3).to receive(:popen3).with(*command)
      .and_yield(nil, nil, StringIO.new("encryption failed"))

    expect { encrypt_file.call }.to raise_error(/encryption failed/)
  end

  describe GpgCommand, "creating the keyring" do
    subject(:gpg_command) { described_class.allocate }

    before do
      gpg_command.instance_variable_set(:@file, file)
      gpg_command.instance_variable_set(:@options, options)
    end

    it "builds the encryption command as separate arguments" do
      expect(gpg_command.to_a).to eq(command)
    end

    it "passes each import option as a separate subprocess argument" do
      allow(Open3).to receive(:capture3)

      gpg_command.send(:create_keyring)

      expect(Open3).to have_received(:capture3).with(
        "gpg",
        "--import",
        "--no-default-keyring",
        "--keyring",
        Rails.root.join("config/gpg/ukrdc_keyring.gpg").to_s,
        Rails.root.join("config/gpg/public_keys/patient-view.asc").to_s
      )
    end
  end
end
