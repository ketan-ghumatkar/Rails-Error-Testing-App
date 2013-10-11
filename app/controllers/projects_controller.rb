class ProjectsController < ApplicationController
  def index
    # Mass Assignment Error
    Project.create(duration:3, name:'mahasangram')
  end

  def new
    Cause.new
  end

  def record_not_found
    User.find(786)
  end
end
