module World
  module Pathology
    module GlobalAlgorithm
      module Domain
        # @section commands
        #
        def set_url_params(url_params, new_param); end
        def get_pathology_request_form(clinician, url_params, patient_ids); end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(patient_id, expected_table); end
        def expect_patient_specific_test(test_description); end
        def expect_no_request_descriptions_required; end
        def expect_request_description_required(request_description_code); end
      end

      module Web
        include Domain
        # @section commands
        #
        def set_url_params(url_params, new_param)
          url_params = {} unless url_params.present?
          url_params.merge(new_param)
        end

        def get_pathology_request_form(clinician, url_params, patient_ids)
          login_as clinician

          url_params = {} unless url_params.present?

          url_params.merge!(patient_ids: patient_ids)
          url = pathology_forms_path(url_params)

          visit url
        end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(patient_id, expected_table)
          table_from_html =
            find_by_id("patient_#{patient_id}_summary")
              .all("tr")
              .map do |row|
                row.all("th, td").map { |cell| cell.text.strip }
              end

          expected_table = expected_table.raw.map do |row|
            row.map do |cell|
              if cell == "TODAYS_DATE"
                I18n.l Date.current
              else
                cell
              end
            end
          end

          expect(table_from_html).to eq(expected_table)
        end

        def expect_patient_specific_test(test_description)
          expect(page).to have_content(test_description)
        end

        def expect_no_request_descriptions_required
          expect(page).to have_content("No tests required.")
        end

        def expect_request_description_required(request_description_code)
          request_description =
            Renalware::Pathology::RequestDescription.find_by(code: request_description_code)
          expect(page.text.downcase).to include(request_description.name.downcase)
        end
      end
    end
  end
end
