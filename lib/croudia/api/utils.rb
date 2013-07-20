module Croudia
  module API
    module Utils

    private

      def get_id(id)
        case id
        when String, Integer
          id
        when Croudia::Identity
          id.id_str
        else
          raise ArgumentError, 'id is invalid'
        end
      end

      def merge_user!(params, user)
        case user
        when Hash
          params.merge!(user)
        when String
          params[:screen_name] = user
        when Integer
          params[:user_id] = user
        when Croudia::User
          params[:user_id] = user.id_str
        else
          raise ArgumentError, 'user must be a String, Integer or User'
        end

        params
      end

      def merge_text!(params, text, key=:status)
        case text
        when Hash
          params.merge!(text)
        else
          params[key] ||= text.to_s
        end

        params
      end

      def objects(klass, array)
        array.map { |hash| klass.new(hash) }
      end
    end
  end
end
