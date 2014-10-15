require 'win32ole'

module WinOle
  class OleExplorer
    def typelibs
      @typelibs ||= WIN32OLE_TYPELIB.typelibs.select {|tl| tl.name unless tl.name.length == 0}
    end

    def ole_classes(typelib)
      begin
        WIN32OLE_TYPE.ole_classes(typelib).collect {|oc| oc.name}.sort
      rescue
        []
      end
    end

    def ole_members(typelib, klass)
      begin
        ot = WIN32OLE_TYPE.new(typelib, klass)
        members = (ot.ole_methods + ot.variables).collect{|om| om.name}.sort
        {:class=>ot, :members=>members}
      rescue
        {:members=>[]}
      end
    end

    def ole_member(typelib, klass, member)
      begin
        ot = WIN32OLE_TYPE.new(typelib, klass)
        (ot.ole_methods + ot.variables).find {|mem| mem.name == member}
      rescue
      end
    end
  end
end
