class GitCommitSha
  def self.current
    new.current
  end

  def current
    sha = development_sha || capistrano_sha || heroku_sha
    sha.present? && sha[0...7]
  end

  private

  def development_sha
    Rails.env.development? && `git rev-parse HEAD`
  end

  def heroku_sha
    sha_from_file(".source_version")
  end

  def capistrano_sha
    sha_from_file("REVISION")
  end

  def sha_from_file(filename)
    file = Rails.root.join(filename)
    File.exist?(file) && File.open(file, &:gets)
  end
end
