require_dependency "renalware/pathology"
require "attr_extras"

module Renalware
  module Pathology
    # A custom relation-like object, implementing a kaminiari-like pagination interface.
    # Its a query object but means to be used like a relation. If passed into a view you can
    # do = paginate(relation).
    # See ObservationsGroupedByDateTable for intended usage.
    #
    # .all() returns a jsonb hash of OBX results for each day a patient had an observation.
    # Only returns observations whose code matches observation_descriptions
    #
    # Example usage:
    #   observation_descriptions = ..
    #   rows = ObservationsGroupedByDateQuery.new(
    #     patient: patient,
    #     observation_descriptions: observation_descriptions,
    #     per_page: 50,
    #     page: 1
    #   )
    #
    # Example output:
    #   patient_id  observation_date  observations
    #   ------------------------------------------
    #   1           2018-02-02        {"CYA": "14"}
    #   1           2016-06-15        {"CMVDNA": "0.10"}
    #   1           2016-03-15        {"NA": "137", "TP": "74", "ALB": "48", "ALP": "71", ...
    #   1           2016-02-29        {"NA": "136", "TP": "78", "ALB": "47", "ALP": "71", ...
    #
    #
    class ObservationsGroupedByDateQuery
      attr_reader :patient, :observation_descriptions, :page, :limit
      alias :current_page :page
      alias :limit_value :limit

      def initialize(patient:, observation_descriptions:, page: 1, per_page: 50)
        @patient = patient
        @observation_descriptions = observation_descriptions
        @page = Integer(page)
        @limit = Integer(per_page)
      end

      def total_pages
        result = conn.execute(to_count_sql)
        total = result.getvalue(0, 0)
        (total.to_f / limit).ceil
      end

      def offset
        (page - 1) * limit
      end

      def all
        conn.execute(to_paginated_sql)
      end

      private

      def to_sql
        <<-SQL.squish
          select obs_req.patient_id, cast(observed_at as date) as observed_on,
          jsonb_object_agg(obs_desc.code, obs.result) results
          from pathology_observations obs
          inner join pathology_observation_requests obs_req on obs.request_id = obs_req.id
          inner join pathology_observation_descriptions obs_desc on obs.description_id = obs_desc.id
          where patient_id = #{conn.quote(patient.id)}
          and obs.description_id in (#{observation_description_ids})
          group by patient_id, observed_on
          order by patient_id asc, observed_on desc
        SQL
      end

      def to_count_sql
        "select count(*) from (#{to_sql}) as query"
      end

      def to_paginated_sql
        to_sql + " limit #{limit} offset #{offset}"
      end

      def conn
        ActiveRecord::Base.connection
      end

      def observation_description_ids
        observation_descriptions.map(&:id).join(",")
      end
    end
  end
end
