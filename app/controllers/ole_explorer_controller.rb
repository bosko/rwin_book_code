require 'ole_explorer'

class OleExplorerController < ApplicationController
  def index
    @typelibs = WinOle::OleExplorer.new.typelibs.collect{|tl| tl.name}.sort
    @ole_classes = []
    @ole_members = {:members=>[]}
    @member = nil
  end

  def update_classes
    @ole_classes = WinOle::OleExplorer.new.ole_classes(params[:typelib])
  end

  def update_members
    @ole_members = WinOle::OleExplorer.new.ole_members(params[:typelib],params[:ole_class])
  end

  def member_info
    @member = WinOle::OleExplorer.new.ole_member(params[:typelib],
      params[:ole_class],
      params[:member])
  end
end
