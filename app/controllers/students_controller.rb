require 'rubygems'
require 'mechanize'
require 'open-uri'

class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  
  $girls_array=%w/31 37 54 55 60 61 67 69 72 73 75 80 83 84 86 87 95 121 175 183 190 195 216 222 229 231 278 284 303 318 332 335 336 341 342 346 347 348 349 352 352 354 355 358 359 360 363 364 366 367 370 372 374 376 377 382 463 469 504 505 507 538 547 551 552 562 563 565 566 569 570 574 575 578 581 583 586 599 600 601 603 605 606 607 609 610 613 621 622 623 624 625 626 627 630 631 633 634 637 674 732 752 756 757 758 760 761 803 807 809 825 864 878 947 991 1005 1006 1020 1056 1059 1084 1085 1090 1105 1107 1112 1127 1135 1147/
  
  def parse
    @students = Student.all
    @a = Mechanize.new
    @a.get('http://class.likelion.net') do |page|
    # Click the login link  
      page.form_with(:action => '/users/sign_in') do |f|
        f.field_with(:name => "user[email]").value = "project42da@naver.com"
        f.field_with(:name => "user[password]").value = "369369369"
      end.submit
    end
      
    @index=0
    
    if @students.length==0
      1.upto(1199).with_index do |i,index|
        @list=Student.new
        @a.get("http://class.likelion.net/home/mypage/#{i}") do |page|
          @list.name = page.search('div.user-profile a')[0].text
          @list.univ = page.search('div.user-profile span.univ')[0].text.delete("| ")
          @list.lecture = page.search(".myprogress-wrapper p.percent")[0].text
          @list.assignment = page.search(".myprogress-wrapper p.percent")[1].text
          @list.image = i.to_s #모든 이미지명을 프로필 순번으로
#          if $girls_array.find_index(i.to_s) #배열에 속한 이미지만 다운받을것.
#            if @i=page.image_with(:src => /http(.*?)/m)
#              @i.fetch.save("app/assets/images/#{i}.jpg")
#            end
#          end
          if @a.page.parser.css('div.user-photo img')[0].attr('src').chr != "/"
            temp = @a.page.parser.css('div.user-photo img')[0].attr('src')
            download = open(temp)
            IO.copy_stream(download, "app/assets/images/pic/#{i}.jpg")
          end
        end
        @list.save
      end
    end
  end
  
  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :univ, :image, :assignment, :lecture)
    end
end
