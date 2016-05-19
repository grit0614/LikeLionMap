require 'roo'
require 'rubygems'
require 'mechanize'
require 'open-uri'

class SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  def import
    School.import(params[:file])
    redirect_to root_url, notice: "CSV import complete"
  end
  
  def parseLogo
    @students = Student.all
    @a = Mechanize.new
    @a.get('http://class.likelion.net') do |page|
    # Click the login link  
      page.form_with(:action => '/users/sign_in') do |f|
        f.field_with(:name => "user[email]").value = "project42da@naver.com"
        f.field_with(:name => "user[password]").value = "369369369"
      end.submit
    end
      
    @a.get("http://class.likelion.net/contacts") do |page|
      0.upto(81) do |i|
        @name = page.search('div.uni-footer')[i].text
        if @a.page.parser.css('div.uni-header img')[i].attr('src').chr != "/"
          temp = @a.page.parser.css('div.uni-header img')[i].attr('src')
          download = open(temp)
          IO.copy_stream(download, "app/assets/images/logo/#{@name}.jpg")
        end
      end
    end
      
  end
  
  
  
  # GET /schools
  # GET /schools.json
  def index
    @schools = School.all
  end

  # GET /schools/1
  # GET /schools/1.json
  def show
  end

  # GET /schools/new
  def new
    @school = School.new
  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools
  # POST /schools.json
  def create
    @school = School.new(school_params)

    respond_to do |format|
      if @school.save
        format.html { redirect_to @school, notice: 'School was successfully created.' }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schools/1
  # PATCH/PUT /schools/1.json
  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to @school, notice: 'School was successfully updated.' }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.json
  def destroy
    @school.destroy
    respond_to do |format|
      format.html { redirect_to schools_url, notice: 'School was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def school_params
      params.require(:school).permit(:name, :num, :lat, :lng)
    end
end
