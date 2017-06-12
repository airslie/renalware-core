class GitCommitSha
  def self.current
    new.current
  end

  def current
    sha = development_sha || capistrano_sha || heroku_sha
    sha.present? && sha[0...6]
  end

  private

  def development_sha
    Rails.env.development? && `git rev-parse HEAD`
  end

  def heroku_sha
    ENV.fetch("SOURCE_VERSION", "N/A")
  end

  def capistrano_sha
    sha_from_file("REVISION")
  end

  def sha_from_file(filename)
    file = Renalware::Engine.root.join(filename)
    File.exist?(file) && File.open(file, &:gets)
  end
end
