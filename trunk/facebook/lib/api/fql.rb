module Facebook
  module Fql
    class << self
      def query(fql)
        hpricot = Facebook.fbsession.fql_query(:query => fql)

        # gsub out the generic "fql_query" root node prefix with the node
        # needed for XML::Mapping to pick the right class for mapping, and
        # specify what of the result to return.
        root_node = nil
        ret       = nil
        if hpricot/'fql_query_response>user' != [] # users.getInfo
          root_node = 'user_getinfo'
          ret       = 'users'
        elsif hpricot/'fql_query_response>group' != [] # groups.get
          root_node = 'groups_get'
          ret       = 'groups'
        elsif hpricot/'fql_query_response>group_member' != [] # groups.getMembers
          root_node = 'groups_getmembers'
        elsif hpricot/'fql_query_response>friend_info' != [] # friends.get
          root_node = 'friends_get'
          ret       = 'uids'
        end

        unless root_node
          raise StandardError, 'Cannot parse fql'
        end

        str = hpricot.to_s
        str.gsub!('fql_query', root_node)

        result = XML::Mapping.load_object_from_xml(REXML::Document.new(str).root)
        if ret
          return result.send(ret)
        else
          return result # groups.getMembers just wants to return what it finds
        end
      end
    end
  end
end
