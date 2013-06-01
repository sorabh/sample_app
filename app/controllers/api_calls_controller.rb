require 'json'
class ApiCallsController < ApplicationController
  # GET /api_calls
  # GET /api_calls.json
  def index
    @api_calls = ApiCall.search(params[:search]).order("created_at desc").paginate(per_page: 10,page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @api_calls }
      format.csv { send_data @api_calls.to_csv(session[:user_id].to_s)}
      format.xls #{ send_data @api_calls.to_csv(col_sep: "\t")}

    end
  end

  # GET /api_calls/1
  # GET /api_calls/1.json
  def show
    @api_call = ApiCall.find(params[:id])
    user_id=@api_call.id
    @user=current_user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @api_call }
    end
  end

  # GET /api_calls/new
  # GET /api_calls/new.json
  def new
    @api_call = ApiCall.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @api_call }
    end
  end

  # GET /api_calls/1/edit
  def edit
    @api_call = ApiCall.find(params[:id])
  end

  # POST /api_calls
  # POST /api_calls.json
  def create
    @api_call = ApiCall.new(params[:api_call])
    ApiCall.make_api_call(@api_call)
    respond_to do |format|
      if @api_call.save
        format.html {redirect_to @api_call, notice: 'Api call was successfully'}
        format.json { render json: @responce }
      else
        format.html { render action: "new" }
        format.json { render json: @api_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api_calls/1
  # PUT /api_calls/1.json
  def update
    @api_call = ApiCall.find(params[:id])

    respond_to do |format|
      if @api_call.update_attributes(params[:api_call])
        format.html { redirect_to @api_call, notice: 'Api call was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @api_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_calls/1
  # DELETE /api_calls/1.json
  def destroy
    @api_call = ApiCall.find(params[:id])
    @api_call.destroy

    respond_to do |format|
      format.html { redirect_to api_calls_url }
      format.json { head :no_content }
      format.js
    end
  end

  def import
    ApiCall.import(params[:file] ,session[:user_id])
    redirect_to api_calls_url ,notice: 'Patients details imported'
  end
end
