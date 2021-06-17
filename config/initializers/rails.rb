# frozen_string_literal: true

# Ruby 3 patch for Redis cache
# picked from https://github.com/rails/rails/commit/b3a0be0f560b558ca121905d7882ef790df67bcc
#
# TODO: remove after upgrade to Rails 6.0.3+
module ActiveSupport
  module Cache
    class RedisCacheStore < Store
      private

      # Write an entry to the cache.
      #
      # Requires Redis 2.6.12+ for extended SET options.
      def write_entry(key, entry, unless_exist: false, raw: false, expires_in: nil, race_condition_ttl: nil, **options)
        serialized_entry = serialize_entry(entry, raw: raw)

        # If race condition TTL is in use, ensure that cache entries
        # stick around a bit longer after they would have expired
        # so we can purposefully serve stale entries.
        if race_condition_ttl && expires_in && expires_in > 0 && !raw
          expires_in += 5.minutes
        end

        failsafe :write_entry, returning: false do
          if unless_exist || expires_in
            modifiers = {}
            modifiers[:nx] = unless_exist
            modifiers[:px] = (1000 * expires_in.to_f).ceil if expires_in

            redis.with { |c| c.set key, serialized_entry, **modifiers }
          else
            redis.with { |c| c.set key, serialized_entry }
          end
        end
      end
    end
  end
end
