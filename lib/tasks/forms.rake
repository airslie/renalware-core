namespace :forms do
  namespace :generic do
    namespace :homecare do
      desc "Generate test Generic Homecare Supply PDF"
      task build: :environment do
        include Forms::Helpers

        args = Forms::Homecare::Args.test_data(provider: :generic)
        pdf = Forms::Homecare::Pdf.generate(args)
        render_and_open pdf
      end
    end
  end
end
